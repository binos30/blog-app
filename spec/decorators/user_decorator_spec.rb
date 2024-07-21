# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserDecorator do
  let(:user) do
    User.create!(email: "jd@gmail.com", password: "pass123", first_name: "John", last_name: "Doe").decorate
  end

  it "returns the full name" do
    expect(user.full_name).to eq("John Doe")
  end

  it "returns the initials" do
    expect(user.initials).to eq("JD")
  end
end
