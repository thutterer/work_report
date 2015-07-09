class PostsController < BaseController

  before_action :set_post, only: [
    :edit,
    :update,
    :destroy
  ]


  def dashboard
    @published_post_count = Post.published.count
    @draft_post_count = Post.drafted.count
    render :template => 'shared/posts/dashboard'
  end

  def index
    @posts = Post.published.page(params[:page]).per(50)
    render :template => 'shared/posts/index'
  end

  def drafts
    @posts = Post.drafted.page(params[:page]).per(50)
    render :template => 'shared/posts/drafts'
  end

  def new
    @post = Post.new
    render :template => 'shared/posts/new'
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_dashboard_path, notice: "New post published."
    else
      flash[:alert] = "Post not published."
      render :template => 'shared/posts/new'
    end
  end

  def edit
    render :template => 'shared/posts/edit'
  end

  def update
    @post.slug = nil
    if @post.update(post_params)
      redirect_to posts_dashboard_path, notice: "Post successfully edited."
    else
      flash[:alert] = "The post was not edited."
      render :template => 'shared/posts/edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "The post has been deleted."
  end


  private

  def set_post
    @post = Post.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(
    :title,
    :content_md,
    :draft,
    :workday,
    :updated_at
    )
  end


end
