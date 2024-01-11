# frozen_string_literal: true

module Sanitizable
  extend ActiveSupport::Concern

  included do
    require "html_scrubbers/wysiwyg_scrubber"
    include ActionView::Helpers::SanitizeHelper
  end
end
