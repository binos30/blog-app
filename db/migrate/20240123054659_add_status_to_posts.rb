class AddStatusToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :status, :integer, default: :public
    add_index :posts, :status

    Post.where(status: nil).find_each { |post| post.public_status! }
  end
end
