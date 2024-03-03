# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostDecorator do
  let(:user) do
    User.create!(email: "jd@gmail.com", password: "pass123", first_name: "John", last_name: "Doe")
  end

  let(:post) { Post.create!(title: "Title", content: "MyText", user:, status: :public).decorate }

  it "returns the author" do
    expect(post.author).to eq("John Doe")
  end

  it "returns the author email" do
    expect(post.author_email).to eq("jd@gmail.com")
  end
end
