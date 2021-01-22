# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

tables = ActiveRecord::Base.connection.tables - ['schema_migrations']

tables.each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table} RESTART IDENTITY CASCADE")
end

User.create(
  firstname: "Fred",
  lastname: "Flintstone",
  email: "fred@flintstone.com",
  password: 'password',
  gender: 'male',
  birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
)

5.times do 
  male_firstname = Faker::Name.unique.male_first_name
  lastname = Faker::Name.unique.last_name
  User.create(
    firstname: male_firstname,
    lastname: lastname,
    email: Faker::Internet.email(name: male_firstname, domain: lastname),
    password: 'password',
    gender: 'male',
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    relationship_status: Faker::Demographic.marital_status,
    bio: Faker::Movie.unique.quote,
    workplace: Faker::Company.name,
    hometown: Faker::Address.city,
    hobbies: Faker::Superhero.power
  )
end

5.times do 
  female_firstname = Faker::Name.unique.female_first_name
  lastname = Faker::Name.unique.last_name
  User.create(
    firstname: female_firstname,
    lastname: lastname,
    email: Faker::Internet.email(name: female_firstname, domain: lastname),
    password: 'password',
    gender: 'female',
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    relationship_status: Faker::Demographic.marital_status,
    bio: Faker::Movie.unique.quote,
    workplace: Faker::Company.name,
    hometown: Faker::Address.city,
    hobbies: Faker::Superhero.power
  )
end

User.male.where.not(lastname: 'Flintstone').each do |user|
  url = URI.parse(Faker::Avatar.image(set: "set2", bgset: "bg1"))
  filename = File.basename(url.path)
  file = URI.open(url)
  user.avatar.attach(io: file, filename: filename)
end
  
User.female.each do |user|
  url = URI.parse(Faker::Avatar.image(set: "set4", bgset: "bg2"))
  filename = File.basename(url.path)
  file = URI.open(url)
  user.avatar.attach(io: file, filename: filename)
end

User.all.each do |user|
  rand(0..3).times do |n|
    friend = User.order(Arel.sql('RANDOM()')).first
    unless user.friends.include?(friend) || friend == user
        user.friends << friend
    end
  end
end

User.all.each do |user|
  rand(0..2).times do |n|
    friend = User.order(Arel.sql('RANDOM()')).first
    unless user.friends.include?(friend) ||
          friend == user ||
          user.friend_requests.pending.where(user_id: user.id, friend_id: friend.id)
          .or(user.friend_requests.pending.where(user_id: friend.id, friend_id: user.id)).any?
      friend_request = 
        FriendRequest.create(
          user_id: friend.id,
          friend_id: user.id,
          status: 'pending',
          created_at: Faker::Date.between(from: 1.year.ago, to: Date.today)
        )
      Notification.create(
        sent_to: user, 
        sent_by: friend,
        status: "unseen",
        action: "sent", 
        notifiable: friend_request,
        created_at: friend_request.created_at
      )
    end                          
  end
end

User.all.each do |user|
  rand(0..20).times do |n|
    Post.create(
      body: Faker::Hipster.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4),
      created_at: Faker::Date.between(from: 1.year.ago, to: Date.today),
      user_id: user.id
    )
  end
end

Post.all.each do |post|
  rand(0..10).times do |n|
    random_user = User.order(Arel.sql('RANDOM()')).first
    Comment.create(
      user_id: random_user.id,
      post_id: post.id,
      body: Faker::Hipster.sentence(word_count: 3, supplemental: false, random_words_to_add: 4),
      created_at: Faker::Date.between(from: post.created_at, to: Date.today)
    )
    Notification.create(
      sent_to: User.find(post.user_id), 
      sent_by: random_user,
      status: "unseen",
      action: "commented", 
      notifiable: post,
      created_at: post.created_at
    )
  end
end

Post.all.each do |post|
  rand(0..10).times do |n|
    random_user = User.order(Arel.sql('RANDOM()')).first
    Like.create(
      user_id: random_user.id,
      post_id: post.id,
      created_at: Faker::Date.between(from: post.created_at, to: Date.today)
    )
    Notification.create(
      sent_to: User.find(post.user_id), 
      sent_by: random_user,
      status: "unseen",
      action: "liked", 
      notifiable: post,
      created_at: post.created_at
    )
  end
end