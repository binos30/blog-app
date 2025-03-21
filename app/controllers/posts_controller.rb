# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :check_user, only: %i[edit update destroy]
  before_action :set_post, only: %i[show edit update destroy]

  # Defines a helper method to access decorated instance variables.
  decorates_assigned :posts, :post, :feedbacks

  # GET /posts
  def index
    posts = Post.includes(%i[user rich_text_content]).public_status(params[:search]).order(updated_at: :desc)
    @pagy, @posts = pagy_countless(posts, limit: 10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /posts/1
  def show
    redirect_to posts_url and return if !@post.public_status? && @post.user_id != current_user&.id

    @post_feedbacks_count = @post.feedbacks.count
    feedbacks = @post.feedbacks.includes([:user]).order(created_at: :desc)
    @pagy, @feedbacks = pagy_countless(feedbacks, limit: 10)
    @feedback = @post.feedbacks.build
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create # rubocop:disable Metrics/AbcSize
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: t("record.create", record: Post.name, name: @post.title) }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotUnique => e
    @post.errors.add(:base, e)
    render :new, status: :unprocessable_entity
  end

  # PATCH/PUT /posts/1
  def update # rubocop:disable Metrics/AbcSize
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: t("record.update", record: Post.name, name: @post.title) }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotUnique => e
    @post.errors.add(:base, e)
    render :edit, status: :unprocessable_entity
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url, notice: t("record.delete", record: Post.name, name: @post.title) }
      format.json { head :no_content }
    end
  end

  def by_author
    posts =
      Post.includes([:rich_text_content]).by_author(current_user.id, params[:search]).order(updated_at: :desc)
    @pagy, @posts = pagy_countless(posts, limit: 10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def check_user
    current_user.posts.find_by_friendly_id(params[:slug]) # rubocop:disable Rails/DynamicFindBy
  rescue ActiveRecord::RecordNotFound
    logger.error "User Post not found #{params[:slug]}"
    redirect_to posts_url, warning: t(:not_authorized)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find_by_friendly_id(params[:slug]) # rubocop:disable Rails/DynamicFindBy
  rescue ActiveRecord::RecordNotFound
    logger.error "Post not found #{params[:slug]}"
    redirect_back(fallback_location: posts_url)
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :content, :status).each_value { |value| value.try(:strip!) }
  end
end
