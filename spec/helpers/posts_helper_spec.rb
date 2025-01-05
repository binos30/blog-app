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
  let!(:user) { create :user, role: }
  let!(:user2) { create :user, role: }
  let(:post) { build_stubbed :post, user: }

  describe "#post_author?" do
    it "returns true if post author is equal to current user" do
      sign_in(user)
      expect(helper.post_author?(post.user_id)).to be true
    end

    it "returns false if post author is not equal to current user" do
      sign_in(user2)
      expect(helper.post_author?(post.user_id)).to be false
    end
  end
end
