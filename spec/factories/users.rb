# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    role
    first_name { "John" }
    last_name { "Doe" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { "password" }

    trait :with_posts do
      transient { posts_count { 2 } }

      after(:build) { |user, evaluator| build_list(:post, evaluator.posts_count, user:) }
    end

    trait :as_admin do
      role { association(:role, :as_admin) }
    end
  end
end
