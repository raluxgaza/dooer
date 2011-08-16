# By using the symbol :user we get factory girl to simulate a User model

Factory.define :user do |user|
  user.full_name  "Ann Sheks"
  user.email "ann@sheks.com"
  user.password "password"
  user.password_confirmation "password"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

