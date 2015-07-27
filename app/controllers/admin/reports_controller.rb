class Admin::ReportsController < Admin::BaseController

  before_action :set_post, only: [
    :edit,
    :update,
    :destroy
  ]


  def dashboard
    @published_report_count = Report.published.count
    @draft_report_count = Report.drafted.count
    render :template => 'shared/reports/dashboard'
  end

  def index
    @reports = Report.published.page(params[:page]).per(50)
    render :template => 'shared/reports/index'
  end

  def drafts
    @reports = Report.drafted.page(params[:page]).per(50)
    render :template => 'shared/reports/drafts'
  end

  def new
    @report = Report.new
    render :template => 'shared/reports/new'
  end

  def create
    @report = Report.new(post_params)
    @report.user_id = current_user.id
    if @report.save
      redirect_to admin_reports_dashboard_path, notice: "New report published."
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
    if @report.update(post_params)
      redirect_to admin_reports_dashboard_path, notice: "Report successfully edited."
    else
      flash[:alert] = "Report was not edited."
      render :template => 'shared/reports/edit'
    end
  end

  def destroy
    @report.destroy
    redirect_to admin_reports_path, notice: "Report deleted."
  end


  private

  def set_post
    @report = Report.friendly.find(params[:id])
  end

  def post_params
    #FIXME this is not fitting the other controllers function! -> broken!
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
