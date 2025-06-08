# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/show" do
  let(:post) { build_stubbed(:post) }

  before do
    assign(:post, post)
    assign(:post_feedbacks_count, post.feedbacks.count)
    assign(:feedback, post.feedbacks.build)

    # Turns off the verifying of partial doubles for the duration of the block,
    # this is useful in situations where methods are defined at run time and you wish
    # to define stubs for them but not turn off partial doubles for the entire run suite.
    without_partial_double_verification { allow(view).to receive(:post).and_return(post.decorate) }
  end

  it "renders attributes" do
    render
    expect(rendered).to match(/Post/)
    expect(rendered).to match(/Content/)
  end
end
