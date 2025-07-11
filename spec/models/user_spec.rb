# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  describe "db_columns" do
    it { should have_db_column(:email).of_type(:string).with_options(null: false, default: "") }
    it { should have_db_column(:encrypted_password).of_type(:string).with_options(null: false, default: "") }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
    it { should have_db_column(:sign_in_count).of_type(:integer).with_options(null: false, default: 0) }
    it { should have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:current_sign_in_ip).of_type(:string) }
    it { should have_db_column(:last_sign_in_ip).of_type(:string) }
    it { should have_db_column(:first_name).of_type(:string).with_options(null: false, default: "") }
    it { should have_db_column(:last_name).of_type(:string).with_options(null: false, default: "") }
    it { should have_db_column(:active).of_type(:boolean).with_options(null: false, default: true) }
    it { should have_db_column(:role_id).of_type(:integer).with_options(null: false) }
  end

  describe "db_indexes" do
    it { should have_db_index(:active) }
    it { should have_db_index(:email).unique }
    it { should have_db_index(:first_name) }
    it { should have_db_index(:last_name) }
    it { should have_db_index(:role_id) }
    it { should have_db_index(:reset_password_token).unique }
  end

  describe "associations" do
    describe "belongs_to" do
      # Use `without_validating_presence` with `belong_to` to prevent the
      # matcher from checking whether the association disallows nil (Rails 5+ only).
      # This can be helpful if you have a custom hook that always sets the association to a meaningful value:
      it { should belong_to(:role).inverse_of(:users).without_validating_presence }
    end

    describe "has_many" do
      it { should have_many(:posts).inverse_of(:user).dependent(:destroy) }
      it { should have_many(:feedbacks).inverse_of(:user).dependent(:destroy) }
      it { should have_many(:posts_feedbacks).through(:posts).source(:feedbacks) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }

      context "when encrypted_password_changed? on update" do
        let(:user) do
          build_stubbed(:user).tap { |u| allow(u).to receive(:encrypted_password_changed?).and_return(true) }
        end

        it "validates presence of password on update" do
          expect(user).to validate_presence_of(:password).on(:update)
        end
      end

      context "when not encrypted_password_changed? on update" do
        let(:user) do
          build_stubbed(:user).tap { |u| allow(u).to receive(:encrypted_password_changed?).and_return(false) }
        end

        it "doesn't validate presence of password on update" do
          expect(user).not_to validate_presence_of(:password).on(:update)
        end
      end
    end

    describe "length" do
      it { should validate_length_of(:email).is_at_most(255) }
      it { should validate_length_of(:first_name).is_at_least(2).is_at_most(100) }
      it { should validate_length_of(:last_name).is_at_least(2).is_at_most(100) }

      context "when encrypted_password_changed? on update" do
        let(:user) do
          build_stubbed(:user).tap { |u| allow(u).to receive(:encrypted_password_changed?).and_return(true) }
        end

        it "validates length of password on update" do
          expect(user).to validate_length_of(:password).on(:update).is_at_least(8).is_at_most(20)
        end
      end

      context "when not encrypted_password_changed? on update" do
        let(:user) do
          build_stubbed(:user).tap { |u| allow(u).to receive(:encrypted_password_changed?).and_return(false) }
        end

        it "doesn't validate length of password on update" do
          expect(user).not_to validate_length_of(:password).on(:update).is_at_least(8).is_at_most(20)
        end
      end
    end

    describe "format" do
      subject { build(:user) }

      describe "first_name" do
        it "accepts a valid value" do
          subject.first_name = "John"
          expect(subject).to be_valid
        end

        it "does not accept an invalid format" do
          subject.first_name = "John-1"
          expect(subject).not_to be_valid
        end
      end

      describe "last_name" do
        it "accepts a valid value" do
          subject.last_name = "Doe"
          expect(subject).to be_valid
        end

        it "does not accept an invalid format" do
          subject.last_name = "Doe-1"
          expect(subject).not_to be_valid
        end
      end
    end

    describe "before_validation .set_role" do
      subject { build(:user, role:) }

      let!(:role) { create(:role, :as_admin) }

      it "sets the role to Administrator" do
        subject.save!
        expect(subject.role.name).to eq("Administrator")
      end

      context "when the role_id is nil" do
        before { subject.role_id = nil }

        it "sets the role to Member" do
          subject.save!
          expect(subject.role.name).to eq("Member")
        end
      end
    end

    describe "new_and_old_password_must_be_different" do
      subject { build_stubbed(:user, password: "password") }

      it "is valid" do
        expect(subject.valid?).to be true
      end

      context "when the password is similar to old" do
        before { subject.password = "password" }

        it "is has an error on password" do
          subject.validate
          expect(subject.errors[:password].first).to eq("Old password not allowed")
        end
      end
    end
  end
end
