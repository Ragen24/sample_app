namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Ragen",
                       email:    "stalker.20122@yandex.ru",
                       password: "qwerty",
                       password_confirmation: "qwerty",
                       admin: true,
                       slug: "ragen")
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    slug = "slug#{n+1}"
    password  = "exampleqwerty"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password,
                 slug: slug)
  end
end

def make_microposts
  users = User.all.limit(6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end