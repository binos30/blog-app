# frozen_string_literal: true

class AddSlugToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true

    remove_index :posts, :title, if_exists: true
    add_index :posts, :title, unique: true

    Post.find_each(&:save)

    change_column_null :posts, :slug, false
  end
end
