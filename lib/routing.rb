# frozen_string_literal: true

module Routing
  extend ActiveSupport::Concern

  included { include Rails.application.routes.url_helpers }

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end
end
