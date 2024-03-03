# frozen_string_literal: true

require "rails_helper"

# Specs in this file have access to a helper object that includes
# the PostsHelper. For example:
#
# describe PostsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PostsHelper do
  let(:user_john) do
    User.create!(email: "jd@gmail.com", password: "pass123", first_name: "John", last_name: "Doe")
  end

  let(:user_jane) do
    User.create!(email: "jdoe@gmail.com", password: "pass123", first_name: "Jane", last_name: "Doe")
  end

  let(:post) do
    Post.create!(
      { user_id: user_john.id, title: "MyPostTitle", content: "MyPostBody", status: :public }
    )
  end

  describe "#post_author?" do
    it "returns true if post author is equal to current user" do
      sign_in(user_john)
      expect(helper.post_author?(post.user_id)).to be true
    end

    it "returns false if post author is not equal to current user" do
      sign_in(user_jane)
      expect(helper.post_author?(post.user_id)).to be false
    end
  end
end
