class ReportsController < BaseController

  before_action :set_post, only: [
    :edit,
    :update,
    :destroy
  ]


  def month
    if defined? params[:monthYear].split
      @month = Date::MONTHNAMES.index(params[:monthYear].split.first).to_i
      @year = params[:monthYear].split.second.to_i
    else
      @month = Time.now.month
      @year = Time.now.year
    end
    if @month
      @workdays = Report.workdays_by_month(@month, @year).order(:workday)

      @secs_in_month = 0
      @workdays.each { |w| @secs_in_month += w.worked_seconds}

      @days = []
      Time.days_in_month(@month, @year).times { |i| @days << "#{@year}-#{format('%02d', @month)}-#{format('%02d', i+1)}"}

      @weeks = Hash.new
      min_week = DateTime.parse(@days.first).strftime('%W').to_i
      max_week = DateTime.parse(@days.last).strftime('%W').to_i
      (min_week..max_week).each { |week| @weeks[week] = [] }

      extra_days_for_week_view = []
      day = DateTime.parse(@days.first).beginning_of_week(start_day = :monday)
      until day.strftime('%F') == @days.first
        extra_days_for_week_view << day.strftime('%F')
        day = day.days_since 1
      end
      day = DateTime.parse(@days.last).end_of_week(start_day = :monday)
      until day.strftime('%F') == @days.last
        extra_days_for_week_view << day.strftime('%F')
        day = day.days_ago 1
      end

      (@days + extra_days_for_week_view).sort.each do |day|
        days_week = DateTime.parse(day).strftime('%W').to_i
        @weeks[days_week] << day if @weeks.keys.include? days_week
      end

      respond_to do |format|
        format.html { render :template => 'shared/posts/month' }
        format.js { render :template => 'shared/posts/month' }
      end

    else
      #FIXME do i need this if/else still? missing respond_to!
      render :template => 'shared/posts/dashboard'
    end
  end

  def dashboard
    @published_post_count = Report.published.count
    @draft_post_count = Report.drafted.count
    render :template => 'shared/posts/dashboard'
  end

  def index
    @posts = Report.published.page(params[:page]).per(50)
    render :template => 'shared/posts/index'
  end

  def show
    @post = Report.friendly.find(params[:id])
    render :template => 'shared/posts/show'
  rescue
    redirect_to root_path
  end

  def drafts
    @posts = Report.drafted.page(params[:page]).per(50)
    render :template => 'shared/posts/drafts'
  end

  def new
    @post = Report.new(title: Time.now.strftime("%R"), workday: Time.now, worked_from: Time.now)
    render :template => 'shared/posts/new'
  end

  def create
    @post = Report.new(post_params)
    @post.user_id = current_user.id
    @post.title = params[:report][:workday]
    if @post.save
      redirect_to reports_month_path, notice: "New post published."
    else
      flash[:alert] = "Report not published."
      render :template => 'shared/posts/new'
    end
  end

  def edit
    render :template => 'shared/posts/edit'
  end

  def update
    @post.slug = nil
    #@post.title = @post.workday.strftime("%Y-%m-%d")
    @post.title = params[:report][:workday]
    if @post.update(post_params)
      redirect_to reports_month_path, notice: "Report successfully edited."
    else
      flash[:alert] = "Report was not edited."
      render :template => 'shared/posts/edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to reports_path, notice: "Report deleted."
  end


  private

  def set_post
    @post = Report.friendly.find(params[:id])
  end

  def post_params
    params.require(:report).permit(
    :title,
    :note,
    :content_md,
    :draft,
    :workday,
    :worked_from,
    :worked_until,
    :updated_at
    )
  end


end
