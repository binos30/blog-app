# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  it "does not save without email and password" do
    user = described_class.new(first_name: "John", last_name: "Doe")
    expect(user.save).to be false
  end

  it "does not save without first name and last name" do
    user = described_class.new(email: "jd@gmail.com", password: "pass123")
    expect(user.save).to be false
  end

  it "saves" do
    user =
      described_class.new(
        email: "jd@gmail.com",
        password: "pass123",
        first_name: "John",
        last_name: "Doe"
      )
    expect(user.save).to be true
  end

  it "updates password" do
    user =
      described_class.new(
        email: "jd@gmail.com",
        password: "pass123",
        first_name: "John",
        last_name: "Doe"
      )
    user.save
    user.update(password: "admin123")
    user.reload
    expect(user.password).to eq("admin123")
  end
end
