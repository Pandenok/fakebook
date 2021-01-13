FactoryBot.define do
  factory :user do
    firstname { Faker::Name.unique.first_name }
    lastname { Faker::Name.unique.last_name }
    password { 'password' }
    password_confirmation { 'password' }
    email { Faker::Internet.email }
  end

  factory :post do
    body { Faker::Hipster.paragraph(sentence_count: 1) }
    user
  end

  factory :like do
    user
    post
  end
end