# frozen_string_literal: true

class AddPlainTextBodyToActionTextRichTexts < ActiveRecord::Migration[7.1]
  def change
    add_column :action_text_rich_texts, :plain_text_body, :text
    add_index :action_text_rich_texts,
              "to_tsvector('english', plain_text_body)",
              using: :gin,
              name: "tsvector_body_idx"

    remove_index :posts, :title, if_exists: true
    add_index :posts, "to_tsvector('english', title)", name: "tsvector_post_title_idx", unique: true

    ActionText::RichText
      .where(plain_text_body: nil)
      .find_each { |rich_text| rich_text.update!(plain_text_body: rich_text.body.to_plain_text) }

    change_column_null :action_text_rich_texts, :plain_text_body, false
  end
end
