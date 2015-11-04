namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Ragen",
                 email: "stalker.20122@yandex.ru",
                 password: "qwerty",
                 password_confirmation: "qwerty",
                 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "exampleqwerty"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end