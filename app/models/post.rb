# frozen_string_literal: true

class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title

  enum :status, { public: 0, private: 1, archived: 2 }, default: :public, suffix: true

  belongs_to :user, inverse_of: :posts

  has_many :feedbacks, inverse_of: :post, dependent: :destroy

  has_rich_text :content

  # broadcasts_refreshes

  validates :title,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            format: %r{\A[a-zA-Z0-9\s\-\[\]/*&;,._:()!?ñÑ]*\z}
  validates :status, inclusion: { in: statuses.keys }
  validates :content, presence: true

  scope :public_status,
        ->(search = "") do
          search = search&.strip

          if search.present?
            joins(:rich_text_content)
              .where(status: :public)
              .where("to_tsvector('english', title) @@ websearch_to_tsquery(?)", search)
              .or(merge(ActionText::RichText.with_body_containing(search)))
          else
            where(status: :public)
          end
        end

  scope :by_author,
        ->(author_id, search = "") do
          search = search&.strip

          if search.present?
            joins(:rich_text_content)
              .where(user_id: author_id)
              .where("to_tsvector('english', title) @@ websearch_to_tsquery(?)", search)
              .or(merge(ActionText::RichText.with_body_containing(search)))
          else
            where(user_id: author_id)
          end
        end

  # Overwrite the setter to rely on validations instead of [ArgumentError]
  # https://github.com/rails/rails/issues/13971#issuecomment-721821257
  def status=(value)
    self[:status] = value
  rescue ArgumentError
    self[:status] = nil
  end

  # Whether to generate a new slug.
  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
