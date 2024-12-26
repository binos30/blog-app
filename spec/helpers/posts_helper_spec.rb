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
RSpec.describe PostsHelper, type: :helper do
  let!(:role) { create :role }
  let!(:user_john) { create :user, role:, first_name: "John", last_name: "Doe", email: "jd@gmail.com" }
  let!(:user_jane) { create :user, role:, first_name: "Jane", last_name: "Doe", email: "jdoe@gmail.com" }
  let!(:post) { create :post, user: user_john }

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
