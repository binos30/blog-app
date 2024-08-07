# frozen_string_literal: true

namespace :db do
  desc "Populates the database with sample data"
  task populate_sample_data: :environment do
    2.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name

      User.create!(
        email: Faker::Internet.email(name: first_name, domain: "gmail.com"),
        password: "pass123",
        first_name:,
        last_name:
      )
    end

    puts "#{User.all.size} users created"

    user = User.first
    user2 = User.last

    15.times do
      Post.create!(title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph_by_chars(number: 256), user:)
    end

    10.times do
      Post.create!(
        title: Faker::Lorem.sentence,
        content: Faker::Lorem.paragraph_by_chars(number: 256),
        user: user2
      )
    end

    puts "#{Post.all.size} posts created"
  end
end
