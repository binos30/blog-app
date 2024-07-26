# frozen_string_literal: true

class UpdateColumns < ActiveRecord::Migration[7.1]
  def up
    add_index :posts, :body
    change_column_null :posts, :status, false
    change_column_null :feedbacks, :body, false
    add_reference :users, :role, foreign_key: true
    add_column :users, :active, :boolean, null: false, default: true
    add_index :users, :active

    member_role = Role.find_or_create_by!(name: "Member")
    User.where(role: nil).find_each { |user| user.update!(role: member_role) }

    change_column_null :users, :role_id, false
  end

  def down
    remove_index :posts, :body
    change_column_null :posts, :status, true
    change_column_null :feedbacks, :body, true
    remove_reference :users, :role, foreign_key: true
    remove_column :users, :active
  end
end
