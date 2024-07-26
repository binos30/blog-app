# frozen_string_literal: true

class MovePostBodyToActionText < ActiveRecord::Migration[7.1]
  def change
    Post.find_each { |post| post.update!(content: post.body) }

    remove_column :posts, :body
  end
end
