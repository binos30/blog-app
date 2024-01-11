# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :correct_user, only: %i[edit update destroy]
  before_action :set_post, only: %i[show edit update destroy]

  # GET /posts
  def index
    @posts = Post.includes([:user]).all
  end

  # GET /posts/1
  def show
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
        format.html do
          redirect_to post_url(@post),
                      notice: t("record.create", record: Post.name, name: @post.title)
        end
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html do
          redirect_to post_url(@post),
                      notice: t("record.update", record: Post.name, name: @post.title)
        end
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html do
        redirect_to posts_url, notice: t("record.delete", record: Post.name, name: @post.title)
      end
      format.json { head :no_content }
    end
  end

  private

  def correct_user
    @post = Post.find_by(id: params[:id], user_id: current_user.id)
    return unless @post.nil?

    flash.now[:warning] = t(:not_authorized)
    redirect_to posts_url
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    logger.error "Post not found #{params[:id]}"
    redirect_back(fallback_location: posts_url)
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body).each_value { |value| value.try(:strip!) }
  end
end
