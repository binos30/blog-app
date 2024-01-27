# frozen_string_literal: true

class PostFeedbackEmailSenderJob < ApplicationJob
  queue_as :default

  def perform(feedback)
    Sendgrid::Templates::PostFeedback.new(feedback).send_email
  end
end
