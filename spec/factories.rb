# By using the symbol :user we get factory girl to simulate a User model

Factory.define :user do |user|
  user.full_name  "Ann Sheks"
  user.email "ann@sheks.com"
  user.password "password"
  user.password_confirmation "password"
end

Factory.define :project do |project|
  project.name "Test 1"
  project.user_id "1"
end

