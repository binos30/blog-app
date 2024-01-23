# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/index" do
  let(:user) do
    User.create!(email: "jd@gmail.com", password: "pass123", first_name: "John", last_name: "Doe")
  end

  before do
    assign(
      :posts,
      [
        Post.create!(title: "Title", body: "MyText", user:, status: :public),
        Post.create!(title: "Title", body: "MyText", user:, status: :public)
      ]
    )
  end

  it "renders a list of posts" do
    render
    title_selector = "h5"
    body_selector = "p"
    assert_select title_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select body_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
