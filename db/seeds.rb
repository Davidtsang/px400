# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name: "Example User",
             email: "123@kejike.com",
             location: "San Francisco, CA",
             password: "12345678",
             password_confirmation: "12345678")
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@kejike.org"
  password = "12345678"
  location= "#{Faker::Address.city}, #{Faker::Address.state}"
  User.create!(name: name,
               email: email,
               password: password,
               location: location,
               password_confirmation: password)


end

users = User.order(:created_at).take(7)

50.times do

  users.each do |user|
    image  = File.open(Dir.glob(File.join(Rails.root, 'public/fake-image/', '*')).sample)
    desciption = Faker::Lorem.sentence(7)
    title = Faker::Lorem.sentence(4)
    work =user.works.create!(desciption: desciption, image: image, title: title)
    #timeline
    Timeline.create(user_id:user.id , work_id:work.id, act:"new")
  end
end

# Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
