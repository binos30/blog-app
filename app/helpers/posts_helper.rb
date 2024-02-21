# frozen_string_literal: true

module PostsHelper
  def post_author?(author_id)
    author_id == current_user&.id
  end
end
