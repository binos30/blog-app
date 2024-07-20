# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeedbackDecorator do
  let(:user) do
    User.create!(
      email: "jd@gmail.com",
      password: "pass123",
      first_name: "John",
      last_name: "Doe"
    )
  end

  let(:post) do
    Post.create!(title: "Title", content: "MyText", user:, status: :public)
  end

  let(:feedback) do
    Feedback.create!(post:, user:, body: "MyFeedbackBody").decorate
  end

  it "returns the author" do
    expect(feedback.author).to eq("John Doe")
  end

  it "returns the author email" do
    expect(feedback.author_email).to eq("jd@gmail.com")
  end
end
