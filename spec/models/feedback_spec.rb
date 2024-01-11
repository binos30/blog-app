# frozen_string_literal: true

require "rails_helper"

RSpec.describe Feedback do
  it "does not save without author" do
    feedback = described_class.new(body: "MyFeedback")
    expect(feedback.save).to be false
  end
end
