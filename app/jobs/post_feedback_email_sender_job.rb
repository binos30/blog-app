# frozen_string_literal: true

require "sendgrid/templates/post_feedback"

class PostFeedbackEmailSenderJob < ApplicationJob
  queue_as :default

  def perform(feedback)
    Templates::PostFeedback.new(feedback).send_email
  end
end
