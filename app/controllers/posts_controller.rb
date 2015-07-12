class PostsController < BaseController

  before_action :set_post, only: [
    :edit,
    :update,
    :destroy
  ]


  def month
    @month = (params[:month] || Time.now.month).to_i
    @year = (params[:year] || Time.now.year).to_i
    if @month
      @workdays = Post.workdays_by_month(@month, @year).order(:workday)
      @secs_in_month = 0
      @workdays.each { |w| @secs_in_month += w.worked_seconds}
      @days = []
      Time.days_in_month(@month, @year).times { |i| @days << "#{@year}-#{format('%02d', @month)}-#{format('%02d', i+1)}"}

      render :template => 'shared/posts/month'
    else
      render :template => 'shared/posts/dashboard'
    end
  end

  def dashboard
    @published_post_count = Post.published.count
    @draft_post_count = Post.drafted.count
    render :template => 'shared/posts/dashboard'
  end

  def index
    @posts = Post.published.page(params[:page]).per(50)
    render :template => 'shared/posts/index'
  end

  def show
    @post = Post.friendly.find(params[:id])
    render :template => 'shared/posts/show'
  rescue
    redirect_to root_path
  end

  def drafts
    @posts = Post.drafted.page(params[:page]).per(50)
    render :template => 'shared/posts/drafts'
  end

  def new
    @post = Post.new(title: Time.now.strftime("%R"), workday: Time.now, worked_from: Time.now)
    render :template => 'shared/posts/new'
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.title = params[:post][:workday]
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
    #@post.title = @post.workday.strftime("%Y-%m-%d")
    @post.title = params[:post][:workday]
    if @post.update(post_params)
      redirect_to posts_dashboard_path, notice: "Workday successfully edited."
    else
      flash[:alert] = "The workday was not edited."
      render :template => 'shared/posts/edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "The workday has been deleted."
  end


  private

  def set_post
    @post = Post.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(
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
