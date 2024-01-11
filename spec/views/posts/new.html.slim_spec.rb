# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/new" do
  before { assign(:post, Post.new(title: "MyString", body: "MyText", user: nil)) }

  it "renders new post form" do
    render

    assert_select "form[action=?][method=?]", posts_path, "post" do
      assert_select "input[name=?]", "post[title]"

      assert_select "textarea[name=?]", "post[body]"
    end
  end
end
