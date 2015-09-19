class ReportsController < BaseController

  before_action :set_post, only: [
    :edit,
    :update,
    :destroy
  ]


  def index
    if defined? params[:monthYear].split
      @month = params[:monthYear].split.first.to_i
      @year = params[:monthYear].split.second.to_i
    else
      @month = Time.now.month
      @year = Time.now.year
    end
    if @month
      # TODO I think I don't need that anywhere anymore ...
      #@secs_in_month = 0
      #current_user.reports.by_month(@month, @year).order(:workday).each { |w| @secs_in_month += w.worked_seconds}

      @days = []
      Time.days_in_month(@month, @year).times { |i| @days << "#{@year}-#{format('%02d', @month)}-#{format('%02d', i+1)}"}

      # TODO move this voodoo into some method
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
        format.html { render :template => 'shared/reports/index', locale: current_user.locale }
        format.js { render :template => 'shared/reports/index', locale: current_user.locale }
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
    workday = DateTime.parse(params[:workday]) rescue Time.now
    @report = Report.new(title: workday.strftime("%R"), workday: workday, worked_from: Time.now)

    respond_to do |format|
      format.html { render :template => 'shared/reports/new' }
      format.js { render 'shared/reports/new' }
    end
  end

  def create
    @report = Report.new(post_params)
    @report.user_id = current_user.id
    if @report.save
      redirect_to reports_path, notice: t('alert.saved')
    else
      flash[:alert] = t('alert.not_saved')
      #FIXME see comment in update method
      render :template => 'shared/reports/new'
    end
  end

  def edit
    render :template => 'shared/reports/edit'
  end

  def update
    @report.slug = nil
    if @report.update(post_params)
      redirect_to reports_path, notice: t('alert.saved')
    else
      flash[:alert] = t(:alert.not_saved)
      #FIXME should refresh modal. not rendering old edit view! remove edit view btw ;)
      render :template => 'shared/reports/edit'
    end
  end

  def destroy
    @report.destroy
    redirect_to reports_path, notice: t('alert.deleted')
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
    :break_duration,
    :worked_until,
    :updated_at
    )
  end


end
