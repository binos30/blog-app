# frozen_string_literal: true

require "rails_helper"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "post/:post_id/feedbacks" do
  let(:user) do
    User.create!(email: "jd@gmail.com", password: "pass123", first_name: "John", last_name: "Doe")
  end
  let(:blog_post) { Post.create!(title: "Title", body: "MyText", user:) }

  # This should return the minimal set of attributes required to create a valid
  # Feedback. As you add validations to Feedback, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { user_id: user.id, body: "MyPostBody" } }

  let(:invalid_attributes) { { body: "" } }

  before { sign_in(user) }

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Feedback" do
        expect do
          post post_feedbacks_url(blog_post), params: { feedback: valid_attributes }
        end.to change(Feedback, :count).by(1)
      end

      it "redirects to the post" do
        post post_feedbacks_url(blog_post), params: { feedback: valid_attributes }
        expect(response).to redirect_to(post_url(blog_post))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Feedback" do
        expect do
          post post_feedbacks_url(blog_post), params: { feedback: invalid_attributes }
        end.not_to change(Feedback, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post post_feedbacks_url(blog_post), params: { feedback: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end