# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def title(page_title)
    content_for :title, "#{t(:title)} | #{page_title}"
  end

  def meta_title(page_title)
    "#{t(:title)} | #{page_title}"
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

  def default_meta_tags # rubocop:disable Metrics/MethodLength
    {
      reverse: true,
      author: "Venus Lumanglas",
      description: "A simple web app for CRUDing a blog post",
      keywords: "article, blog, blog article, blog post, blog site, post",
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url("logo.svg") },
        { href: image_url("logo.svg"), rel: "apple-touch-icon", sizes: "180x180", type: "image/svg+xml" }
      ],
      og: {
        title: t(:title),
        description: "A simple web app for CRUDing a blog post",
        type: "website",
        url: request.original_url,
        image: image_url("instablog.png")
      },
      twitter: {
        title: t(:title),
        description: "A simple web app for CRUDing a blog post",
        card: "summary",
        url: request.original_url,
        image: image_url("instablog.png")
      }
    }
  end
end
