# frozen_string_literal: true

require "sendgrid/templates/post_feedback"

class Feedback < ApplicationRecord
  include Sanitizable

  belongs_to :post
  belongs_to :user

  validate :validate_body

  before_save :sanitize_fields
  after_create :send_email

  private

  def validate_body
    errors.add(:base, "Feedback can't be blank") if body.blank?
    return unless body.length < 5
    errors.add(:base, "Feedback is too short (minimum is 5 characters)")
  end

  def sanitize_fields
    self.body = sanitize(body, scrubber: WysiwygScrubber.new)
  end

  def send_email
    Templates::PostFeedback.new(self).send_email
  end
end
