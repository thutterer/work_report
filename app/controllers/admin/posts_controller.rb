class Admin::PostsController < Admin::BaseController

  before_action :set_post, only: [
    :edit,
    :update,
    :destroy
  ]


  def dashboard
    @published_post_count = Report.published.count
    @draft_post_count = Report.drafted.count
    render :template => 'shared/posts/dashboard'
  end

  def index
    @posts = Report.published.page(params[:page]).per(50)
    render :template => 'shared/posts/index'
  end

  def drafts
    @posts = Report.drafted.page(params[:page]).per(50)
    render :template => 'shared/posts/drafts'
  end

  def new
    @post = Report.new
    render :template => 'shared/posts/new'
  end

  def create
    @post = Report.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to admin_posts_dashboard_path, notice: "New post published."
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
    if @post.update(post_params)
      redirect_to admin_posts_dashboard_path, notice: "Report successfully edited."
    else
      flash[:alert] = "The post was not edited."
      render :template => 'shared/posts/edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "The post has been deleted."
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
