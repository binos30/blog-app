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

  # Pretty prints (formats and approximates) a number in a way it is more readable by humans
  # (e.g.: 1200000000 becomes "1.2B")
  def format_number_to_human(number)
    number_to_human(
      number,
      precision: 1,
      significant: false,
      round_mode: :down,
      format: "%n%u",
      units: {
        thousand: "K",
        million: "M",
        billion: "B"
      }
    )
  end
end
