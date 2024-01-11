# frozen_string_literal: true

module PostsHelper
  def post_author?(post)
    return false unless user_signed_in?

    post.user_id == current_user.id
  end

  def can_feedback?(post)
    post.user_id != current_user&.id
  end
end
