User.create!(
  name: "Fake Kev",
  email: "fake-kev@spoofy.forger",
  password: "password",
  password_confirmation: "password",
  admin: true
)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@spoofy.forger"
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password
  )
end

