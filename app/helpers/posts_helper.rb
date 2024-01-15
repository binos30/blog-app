# frozen_string_literal: true

module PostsHelper
  def post_author?(post)
    post.user_id == current_user&.id
  end
end
