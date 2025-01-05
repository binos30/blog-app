# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserDecorator, type: :decorator do
  let(:user) { build_stubbed(:user, first_name: "John", last_name: "Doe").decorate }

  it "returns the full name" do
    expect(user.full_name).to eq("John Doe")
  end

  it "returns the initials" do
    expect(user.initials).to eq("JD")
  end

  describe ".administrator?" do
    let(:user) { build_stubbed(:user, :as_admin).decorate }

    it "returns true" do
      expect(user.administrator?).to be true
    end

    context "when the role is Member" do
      let(:user) { build_stubbed(:user).decorate }

      it "returns false" do
        expect(user.administrator?).to be false
      end
    end
  end
end
