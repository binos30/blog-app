# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostFeedbackEmailSenderJob, type: :job do
  describe "#perform_later" do
    subject(:job) { described_class.perform_later(feedback) }

    let!(:role) { create :role }
    let!(:user_john) { create :user, role:, first_name: "John", last_name: "Doe", email: "jd@gmail.com" }
    let!(:user_jane) { create :user, role:, first_name: "Jane", last_name: "Doe", email: "jdoe@gmail.com" }
    let!(:post) { create :post, user: user_john }
    let!(:feedback) { create :feedback, post:, user: user_jane }

    it "queues the job" do
      ActiveJob::Base.queue_adapter = :test
      expect { job }.to have_enqueued_job(described_class).with(feedback).on_queue("test_default")
    end
  end
end
