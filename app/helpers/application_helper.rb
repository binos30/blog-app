# frozen_string_literal: true

module ApplicationHelper
  def title(page_title)
    content_for :title, "#{t(:title)} | #{page_title}"
  end

  def active_class(path)
    current_page?(path) ? "active" : ""
  end

  def logger
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = ::Logger::Formatter.new

    ActiveSupport::TaggedLogging.new(logger)
  end
end
