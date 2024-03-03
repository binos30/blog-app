# frozen_string_literal: true

class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title

  enum status: { public: 0, private: 1, archived: 2 }, _default: :public, _suffix: true

  belongs_to :user
  has_many :feedbacks, dependent: :destroy

  has_rich_text :content

  validates :title,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            format: %r{\A[a-zA-Z0-9\s\-\[\]/*&;,._:()!?ñÑ]*\z}
  validates :status, presence: true, inclusion: { in: statuses.keys }
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

  # Whether to generate a new slug.
  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
