# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserDecorator, type: :decorator do
  let(:user) { build(:user, first_name: "John", last_name: "Doe", email: "jd@gmail.com").decorate }

  it "returns the full name" do
    expect(user.full_name).to eq("John Doe")
  end

  it "returns the initials" do
    expect(user.initials).to eq("JD")
  end

  describe ".administrator?" do
    let(:user) { build(:user, :as_admin, first_name: "John", last_name: "Doe", email: "jd@gmail.com").decorate }

    it "returns true" do
      expect(user.administrator?).to be true
    end

    context "when the role is Member" do
      let(:user) { build(:user, first_name: "John", last_name: "Doe", email: "jd@gmail.com").decorate }

      it "returns false" do
        expect(user.administrator?).to be false
      end
    end
  end
end
