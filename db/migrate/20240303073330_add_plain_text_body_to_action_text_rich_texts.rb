class AddPlainTextBodyToActionTextRichTexts < ActiveRecord::Migration[7.1]
  def change
    add_column :action_text_rich_texts, :plain_text_body, :text
    add_index :action_text_rich_texts,
              "to_tsvector('english', plain_text_body)",
              using: :gin,
              name: "tsvector_body_idx"

    remove_index :posts, :title, if_exists: true
    add_index :posts,
              "to_tsvector('english', title)",
              name: "tsvector_post_title_idx",
              unique: true

    ActionText::RichText.find_each(&:save)

    change_column_null :action_text_rich_texts, :plain_text_body, false
  end
end
