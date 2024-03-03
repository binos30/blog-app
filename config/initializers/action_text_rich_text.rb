# frozen_string_literal: true

ActiveSupport.on_load :action_text_rich_text do
  before_save { self.plain_text_body = body.to_plain_text }

  scope :with_body_containing, ->(query) { where <<~SQL.squish, query }
    to_tsvector('english', plain_text_body) @@ websearch_to_tsquery(?)
  SQL
end
