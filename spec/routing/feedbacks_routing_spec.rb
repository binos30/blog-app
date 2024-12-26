# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeedbacksController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/posts/:post_slug/feedbacks").to route_to(
        controller: "feedbacks",
        action: "create",
        post_slug: ":post_slug"
      )
    end
  end
end
