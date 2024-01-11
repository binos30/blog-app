# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/show" do
  let(:user) do
    User.create!(email: "jd@gmail.com", password: "pass123", first_name: "John", last_name: "Doe")
  end

  before { assign(:post, Post.create!(title: "Title", body: "MyText", user:)) }

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
