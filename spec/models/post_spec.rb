# frozen_string_literal: true

require "rails_helper"

RSpec.describe Post, type: :model do
  describe "db_columns" do
    it { should have_db_column(:title).of_type(:string).with_options(null: false, default: "") }
    it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:status).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:slug).of_type(:string).with_options(null: false) }
  end

  describe "db_indexes" do
    it { should have_db_index("to_tsvector('english'::regconfig, (title)::text)").unique }
    it { should have_db_index(:slug).unique }
    it { should have_db_index(:status) }
    it { should have_db_index(:user_id) }
  end

  describe "associations" do
    describe "belongs_to" do
      it { should belong_to(:user).inverse_of(:posts) }
    end

    describe "has_one" do
      it { should have_rich_text(:content) }
    end

    describe "has_many" do
      it { should have_many(:feedbacks).inverse_of(:post).dependent(:destroy) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:content) }
    end

    describe "inclusion" do
      it { should validate_inclusion_of(:status).in_array(Post.statuses.keys) }
    end

    describe "uniqueness" do
      subject { build :post }

      it { should validate_uniqueness_of(:title).case_insensitive }
    end

    describe "format" do
      subject { build :post }

      describe "title" do
        it "accepts a valid value" do
          subject.title = "Post"
          expect(subject).to be_valid
        end

        it "does not accept an invalid format" do
          subject.title = "Post<1>"
          expect(subject).to be_invalid
        end
      end
    end
  end
end
