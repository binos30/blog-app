# frozen_string_literal: true

class Post < ApplicationRecord
  include Sanitizable

  belongs_to :user

  validates :title, presence: true, format: %r{\A[a-zA-Z0-9\s\-\[\]/*&;,._:()!?ñÑ]*\z}
  validates :body, presence: true, length: { minimum: 5 }

  before_save :sanitize_fields

  private

  def sanitize_fields
    self.body = sanitize(body, scrubber: WysiwygScrubber.new)
  end
end
