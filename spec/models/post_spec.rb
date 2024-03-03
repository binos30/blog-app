# frozen_string_literal: true

require "rails_helper"

RSpec.describe Post do
  it "does not save without author" do
    post = described_class.new(title: "MyPostTitle", content: "MyPostBody")
    expect(post.save).to be false
  end
end
