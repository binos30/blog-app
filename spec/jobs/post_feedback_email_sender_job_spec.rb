# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostFeedbackEmailSenderJob do
  describe "#perform_later" do
    subject(:job) { described_class.perform_later(feedback) }

    let!(:role) { create(:role) }
    let!(:user) { create(:user, role:) }
    let!(:user2) { create(:user, role:) }
    let!(:post) { create(:post, user:) }
    let!(:feedback) { create(:feedback, post:, user: user2) }

    it "queues the job" do
      ActiveJob::Base.queue_adapter = :test
      expect { job }.to have_enqueued_job(described_class).with(feedback).on_queue("test_default")
    end
  end
end
