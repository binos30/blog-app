# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/posts").to route_to("posts#index")
    end

    it "routes to #new" do
      expect(get: "/posts/new").to route_to("posts#new")
    end

    it "routes to #show" do
      expect(get: "/posts/1").to route_to("posts#show", slug: "1")
    end

    it "routes to #edit" do
      expect(get: "/posts/1/edit").to route_to("posts#edit", slug: "1")
    end

    it "routes to #create" do
      expect(post: "/posts").to route_to("posts#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/posts/1").to route_to("posts#update", slug: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/posts/1").to route_to("posts#update", slug: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/posts/1").to route_to("posts#destroy", slug: "1")
    end
  end
end
