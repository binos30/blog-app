# frozen_string_literal: true

FactoryBot.define do
  factory :feedback do
    post
    user
    body { "Feedback body" }
  end
end
