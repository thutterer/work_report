class Admin::ReportsController < Admin::BaseController

  before_action :set_post, only: [
    :edit,
    :update,
    :destroy
  ]


  def dashboard
    @published_post_count = Report.published.count
    @draft_post_count = Report.drafted.count
    render :template => 'shared/reports/dashboard'
  end

  def index
    @posts = Report.published.page(params[:page]).per(50)
    render :template => 'shared/reports/index'
  end

  def drafts
    @posts = Report.drafted.page(params[:page]).per(50)
    render :template => 'shared/reports/drafts'
  end

  def new
    @post = Report.new
    render :template => 'shared/reports/new'
  end

  def create
    @post = Report.new(post_params)
    @post.user_id = current_user.id
    if @post.save
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
    @post.slug = nil
    if @post.update(post_params)
      redirect_to admin_reports_dashboard_path, notice: "Report successfully edited."
    else
      flash[:alert] = "Report was not edited."
      render :template => 'shared/reports/edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_reports_path, notice: "Report deleted."
  end


  private

  def set_post
    @post = Report.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(
    :title,
    :content_md,
    :draft,
    :updated_at
    )
  end


end
