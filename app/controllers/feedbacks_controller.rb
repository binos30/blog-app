# frozen_string_literal: true

class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  # Defines a helper method to access decorated instance variables.
  decorates_assigned :post

  # POST /feedbacks
  def create # rubocop:disable Metrics/AbcSize
    @post = Post.find(params[:post_slug])
    @feedback = @post.feedbacks.new(feedback_params.merge!(user: current_user))

    respond_to do |format|
      if @feedback.save
        format.html do
          redirect_to @post, notice: t("record.create", record: Feedback.name, name: "")
        end
        format.json { render "posts/show", status: :created, location: @post }
      else
        format.html { render "posts/show", status: :unprocessable_entity }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    logger.error "Post not found #{params[:post_slug]}"
    redirect_back(fallback_location: posts_url)
  end

  private

  # Only allow a list of trusted parameters through.
  def feedback_params
    params.require(:feedback).permit(:body).each_value { |value| value.try(:strip!) }
  end
end
