# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeedbacksController do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/posts/:post_id/feedbacks").to route_to(
        controller: "feedbacks",
        action: "create",
        post_id: ":post_id"
      )
    end
  end
end
