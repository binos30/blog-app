# frozen_string_literal: true

class Post < ApplicationRecord
  include Sanitizable
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum status: { public: 0, private: 1, archived: 2 }, _default: :public, _suffix: true

  belongs_to :user
  has_many :feedbacks, dependent: :destroy

  validates :title,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            format: %r{\A[a-zA-Z0-9\s\-\[\]/*&;,._:()!?ñÑ]*\z}
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :body, presence: true, length: { minimum: 5 }

  before_save :sanitize_fields

  scope :public_status,
        ->(search = "") do
          search = search&.strip

          if search.present?
            where(status: :public).where(
              "title ILIKE :search OR body ILIKE :search",
              search: "%#{search}%"
            )
          else
            where(status: :public)
          end
        end
  scope :by_author,
        ->(author_id, search = "") do
          search = search&.strip

          if search.present?
            where(user_id: author_id).where(
              "title ILIKE :search OR body ILIKE :search",
              search: "%#{search}%"
            )
          else
            where(user_id: author_id)
          end
        end

  private

  def sanitize_fields
    self.body = sanitize(body, scrubber: HtmlScrubbers::WysiwygScrubber.new)
  end
end
