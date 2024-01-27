# frozen_string_literal: true

class Feedback < ApplicationRecord
  include Sanitizable

  belongs_to :post
  belongs_to :user

  validate :validate_body

  before_save :sanitize_fields

  # Send email only if feedback author is not equal to blog post author
  after_create_commit :send_feedback_email, if: :can_send_email?

  private

  def validate_body
    errors.add(:base, "Feedback can't be blank") if body.blank?
    return if body.length >= 5
    errors.add(:base, "Feedback is too short (minimum is 5 characters)")
  end

  def sanitize_fields
    self.body = sanitize(body, scrubber: HtmlScrubbers::WysiwygScrubber.new)
  end

  def send_feedback_email
    PostFeedbackEmailSenderJob.perform_later(self)
  end

  def can_send_email?
    (user_id != post.user_id) && !Rails.env.test? && ENV["SENDGRID_API_KEY"].present?
  end
end
