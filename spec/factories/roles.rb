# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { "Member" }

    trait :as_admin do
      name { "Administrator" }
    end
  end
end
