# frozen_string_literal: true

require "sendgrid-ruby"

# This handles the email sending via SendGrid API.
# Params:
#   mail_object:   Mail object instance containing the initial basic settings.
#   recipients:    JSON array containing the email, name and type of the recipients. The
#                  recipient type can be either of the following: 'to', 'cc' or 'bcc'.
#   substitutions: JSON array of all the substitution values from the keys in the template.
#
module Sendgrid
  class SgMailer
    attr_reader :mail, :recipients, :substitutions, :personalization

    def initialize(mail_object, recipients, substitutions = [])
      @mail = mail_object
      @recipients = recipients
      @substitutions = substitutions
      @personalization = SendGrid::Personalization.new

      set_personalizations
    end

    def send_mail
      sg = SendGrid::API.new(api_key: ENV.fetch("SENDGRID_API_KEY", nil))
      sg.client.mail._("send").post(request_body: mail.to_json)
    end

    private

    # Set the needed personalizations.
    def set_personalizations
      set_recipients
      set_substitutions if substitutions.any?
      mail.add_personalization(personalization)
    end

    # Set the personalization recipients.
    def set_recipients # rubocop:disable Metrics/AbcSize
      recipients.each do |recipient|
        case recipient["type"]
        when "bcc"
          personalization.add_bcc(
            SendGrid::Email.new(email: recipient["email"], name: recipient["name"])
          )
        when "cc"
          personalization.add_cc(
            SendGrid::Email.new(email: recipient["email"], name: recipient["name"])
          )
        when "to"
          personalization.add_to(
            SendGrid::Email.new(email: recipient["email"], name: recipient["name"])
          )
        end
      end
    end

    # Set the personalization substitutions.
    def set_substitutions
      substitutions.each do |substitution|
        personalization.add_dynamic_template_data(substitution["key"] => substitution["value"])
      end
    end
  end
end
