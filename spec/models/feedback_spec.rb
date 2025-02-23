# frozen_string_literal: true

require "rails_helper"

RSpec.describe Feedback, type: :model do
  describe "db_columns" do
    it { should have_db_column(:body).of_type(:text).with_options(null: false) }
    it { should have_db_column(:post_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) }
  end

  describe "db_indexes" do
    it { should have_db_index(:post_id) }
    it { should have_db_index(:user_id) }
  end

  describe "associations" do
    describe "belongs_to" do
      it { should belong_to(:post).inverse_of(:feedbacks) }
      it { should belong_to(:user).inverse_of(:feedbacks) }
    end
  end

  describe "validations" do
    describe "validate_body" do
      subject { build :feedback }

      it "is valid" do
        expect(subject.valid?).to be true
      end

      context "when the body is nil" do
        before { subject.body = nil }

        it "is has an error on body" do
          subject.validate
          expect(subject.errors[:base].first).to eq("Feedback can't be blank")
        end
      end
    end
  end
end
