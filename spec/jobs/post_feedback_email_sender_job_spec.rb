# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostFeedbackEmailSenderJob do
  describe "#perform_later" do
    subject(:job) { described_class.perform_later(feedback) }

    let(:user_john) do
      User.create!(email: "jd@gmail.com", password: "pass123", first_name: "John", last_name: "Doe")
    end

    let(:user_jane) do
      User.create!(
        email: "jdoe@gmail.com",
        password: "pass123",
        first_name: "Jane",
        last_name: "Doe"
      )
    end

    let(:blog_post) { Post.create!(title: "Title", body: "MyText", user: user_john) }

    let(:feedback) { { post: blog_post, user: user_jane, body: "MyFeedbackBody" } }

    it "queues the job" do
      ActiveJob::Base.queue_adapter = :test
      expect { job }.to have_enqueued_job(described_class).with(feedback).on_queue("test_default")
    end
  end
end
