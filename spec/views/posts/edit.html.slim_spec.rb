# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/edit" do
  let(:user) do
    User.create!(email: "jd@gmail.com", password: "pass123", first_name: "John", last_name: "Doe")
  end

  let(:post) { Post.create!(title: "MyString", body: "MyText", user:, status: :public) }

  before { assign(:post, post) }

  it "renders the edit post form" do
    render

    assert_select "form[action=?][method=?]", post_path(post), "post" do
      assert_select "input[name=?]", "post[title]"

      assert_select "textarea[name=?]", "post[body]"
    end
  end
end
