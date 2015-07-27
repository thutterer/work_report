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
        format.html { render :template => 'shared/reports/month' }
        format.js { render :template => 'shared/reports/month' }
      end

    else
      #FIXME do i need this if/else still? missing respond_to!
      render :template => 'shared/reports/dashboard'
    end
  end

  def dashboard
    @published_report_count = Report.published.count
    @draft_report_count = Report.drafted.count
    render :template => 'shared/reports/dashboard'
  end

  def index
    @reports = Report.published.page(params[:page]).per(50)
    render :template => 'shared/reports/index'
  end

  def show
    @report = Report.friendly.find(params[:id])
    render :template => 'shared/reports/show'
  rescue
    redirect_to root_path
  end

  def drafts
    @reports = Report.drafted.page(params[:page]).per(50)
    render :template => 'shared/reports/drafts'
  end

  def new
    @report = Report.new(title: Time.now.strftime("%R"), workday: Time.now, worked_from: Time.now)
    render :template => 'shared/reports/new'
  end

  def create
    @report = Report.new(post_params)
    @report.user_id = current_user.id
    @report.title = params[:report][:workday]
    if @report.save
      redirect_to reports_month_path, notice: "New report published."
    else
      flash[:alert] = "Report not published."
      render :template => 'shared/reports/new'
    end
  end

  def edit
    render :template => 'shared/reports/edit'
  end

  def update
    @report.slug = nil
    #@report.title = @report.workday.strftime("%Y-%m-%d")
    @report.title = params[:report][:workday]
    if @report.update(post_params)
      redirect_to reports_month_path, notice: "Report successfully edited."
    else
      flash[:alert] = "Report was not edited."
      render :template => 'shared/reports/edit'
    end
  end

  def destroy
    @report.destroy
    redirect_to reports_path, notice: "Report deleted."
  end


  private

  def set_post
    @report = Report.friendly.find(params[:id])
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