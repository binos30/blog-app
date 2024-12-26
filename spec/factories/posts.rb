# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    user
    sequence(:title) { |n| "Post #{n}" }
    content { "Content" }
    status { :public }

    trait :with_feedbacks do
      transient { feedbacks_count { 2 } }

      after(:build) { |post, evaluator| build_list(:feedback, evaluator.feedbacks_count, post:) }
    end
  end
end
