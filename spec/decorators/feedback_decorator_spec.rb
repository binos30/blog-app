# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeedbackDecorator, type: :decorator do
  let(:user) { build :user, first_name: "John", last_name: "Doe", email: "jd@gmail.com" }
  let(:post) { build :post, user: }
  let(:feedback) { build(:feedback, post:, user:).decorate }

  it "returns the author" do
    expect(feedback.author).to eq("John Doe")
  end

  it "returns the author email" do
    expect(feedback.author_email).to eq("jd@gmail.com")
  end
end
