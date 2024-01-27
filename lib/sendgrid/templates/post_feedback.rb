# frozen_string_literal: true

require "sendgrid-ruby"

module Sendgrid
  module Templates
    class PostFeedback
      include ApplicationHelper

      attr_reader :feedback, :post

      def initialize(feedback)
        @feedback = feedback
        @post = feedback.post
      end

      def send_email # rubocop:disable Metrics/AbcSize
        mail = SendGrid::Mail.new
        mail.add_category(SendGrid::Category.new(name: "Post Feedback"))
        mail.add_content(SendGrid::Content.new(type: "text/html", value: html_content))
        mail.from =
          SendGrid::Email.new(
            email: ENV.fetch("SENDGRID_FROM_EMAIL", nil),
            name: ENV.fetch("SENDGRID_FROM_NAME", nil)
          )
        mail.reply_to =
          SendGrid::Email.new(email: feedback.user.email, name: feedback.user.full_name)
        mail.subject = "Post##{feedback.post_id} Feedback"

        # Set the recipients. You can specify recipient type to: 'to', 'cc' or 'bcc'.
        recipients = [{ "email" => post.author_email, "name" => post.author, "type" => "to" }]

        # Set the subtitution values to the template keys.
        # Example: [{ "key" => "postTitle", "value" => post.title }]
        substitutions = []

        response = SgMailer.new(mail, recipients, substitutions).send_mail
        status_code = response.status_code

        if status_code.to_i.between?(200, 299)
          description = "Sent post feedback email with Response Code: #{status_code}"
          logger.tagged("SendGrid", "PostFeedback") { logger.info(description) }
        else
          description = "Unable to send post feedback email with Response Code: #{status_code}"
          logger.tagged("SendGrid", "PostFeedback") { logger.error(description) }
        end
      end

      private

      def html_content
        blog_post_url = UrlGenerator.new.post_url(post)
        "<div>
          Hi #{post.author},
          <br/>
          Someone has a feedback on your <a href='#{blog_post_url}' target='_blank'>blog post</a>.
          Read below
          <br/>
          <br/>
          #{feedback.body}
        </div>"
      end
    end
  end
end
