# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/show" do
  let(:user) do
    User.create!(email: "jd@gmail.com", password: "pass123", first_name: "John", last_name: "Doe")
  end

  let(:post) { Post.create!(title: "Title", content: "MyText", user:, status: :public) }

  before do
    assign(:post, post)
    assign(:feedback, post.feedbacks.build)

    # Turns off the verifying of partial doubles for the duration of the block,
    # this is useful in situations where methods are defined at run time and you wish
    # to define stubs for them but not turn off partial doubles for the entire run suite.
    without_partial_double_verification { allow(view).to receive(:post).and_return(post.decorate) }
  end

  it "renders attributes" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
