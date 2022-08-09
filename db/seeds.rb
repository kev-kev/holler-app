User.create!(
  name: "Fake Kev",
  email: "fake-kev@spoofy.forger",
  password: "password",
  password_confirmation: "password",
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@spoofy.forger"
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
end

users = User.first(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content)}
end

user = User.first
users = User.all
users[2..50].each { |other_user| user.follow(other_user) }
users[4..40].each { |other_user| other_user.follow(user) }
