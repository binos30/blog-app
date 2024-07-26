# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false, default: ""
      t.text :body, null: false, default: ""
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :posts, :title
  end
end
