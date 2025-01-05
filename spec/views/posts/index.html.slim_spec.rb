# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/index", type: :view do
  let(:user) { build_stubbed :user }
  let(:posts) { build_stubbed_list :post, 2, user: }

  before do
    @pagy, @posts = pagy_array(posts)

    # Turns off the verifying of partial doubles for the duration of the block,
    # this is useful in situations where methods are defined at run time and you wish
    # to define stubs for them but not turn off partial doubles for the entire run suite.
    without_partial_double_verification do
      allow(view).to receive(:posts).and_return(PostDecorator.decorate_collection(posts))
    end
  end

  it "renders a list of posts" do
    render
    title_selector = "h5"
    content_selector = "div.card-text"
    assert_select title_selector, text: Regexp.new("Post"), count: 2
    assert_select content_selector, text: Regexp.new("Content"), count: 2
  end
end
