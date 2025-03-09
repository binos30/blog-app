# frozen_string_literal: true

class FeedbacksController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: %i[index create]

  # Defines a helper method to access decorated instance variables.
  decorates_assigned :post, :feedbacks

  def index
    feedbacks = @post.feedbacks.includes([:user]).order(created_at: :desc)
    @pagy, @feedbacks = pagy_countless(feedbacks, limit: 10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # POST /feedbacks
  def create # rubocop:disable Metrics/AbcSize
    @feedback = @post.feedbacks.new(feedback_params.merge!(user: current_user))

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @post, notice: t("record.create", record: Feedback.name, name: "") }
        format.json { render "posts/show", status: :created, location: @post }
      else
        format.html do
          @post_feedbacks_count = @post.feedbacks.count
          feedbacks = @post.feedbacks.includes([:user]).order(created_at: :desc)
          @pagy, @feedbacks = pagy_countless(feedbacks, limit: 10)
          render "posts/show", status: :unprocessable_entity
        end
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find_by_friendly_id(params[:post_slug]) # rubocop:disable Rails/DynamicFindBy
  rescue ActiveRecord::RecordNotFound
    logger.error "Post not found #{params[:post_slug]}"
    redirect_back(fallback_location: posts_url)
  end

  # Only allow a list of trusted parameters through.
  def feedback_params
    params.require(:feedback).permit(:body).each_value { |value| value.try(:strip!) }
  end
end
