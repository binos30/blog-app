# frozen_string_literal: true

class PostDecorator < ApplicationDecorator
  decorates_association :user

  def author
    user.full_name
  end

  def author_email
    user.email
  end

  def created_time_ago
    "#{time_ago_in_words(created_at, include_seconds: true)} ago"
  end

  def updated_time_ago
    "#{time_ago_in_words(updated_at, include_seconds: true)} ago"
  end
end
