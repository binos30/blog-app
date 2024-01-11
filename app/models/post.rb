# frozen_string_literal: true

class Post < ApplicationRecord
  include Sanitizable

  belongs_to :user
  has_many :feedbacks, dependent: :destroy

  validates :title, presence: true, format: %r{\A[a-zA-Z0-9\s\-\[\]/*&;,._:()!?ñÑ]*\z}
  validates :body, presence: true, length: { minimum: 5 }

  before_save :sanitize_fields

  def author
    user.full_name
  end

  def author_email
    user.email
  end

  private

  def sanitize_fields
    self.body = sanitize(body, scrubber: WysiwygScrubber.new)
  end
end
