# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#init Domain

#tag status 2 is public

Domain.create(name: "书法", status: 2)
Domain.create(name: "交互设计", status: 2)
Domain.create(name: "产品设计", status: 2)
Domain.create(name: "修图", status: 2)
Domain.create(name: "创意指导", status: 2)
Domain.create(name: "动态图像设计", status: 2)
Domain.create(name: "动画", status: 2)
Domain.create(name: "包装", status: 2)
Domain.create(name: "化妆艺术", status: 2)
Domain.create(name: "印刷设计", status: 2)
Domain.create(name: "品牌推广", status: 2)
Domain.create(name: "图形(平面)设计", status: 2)
Domain.create(name: "图标设计", status: 2)
Domain.create(name: "图案设计", status: 2)
Domain.create(name: "字体设计", status: 2)
Domain.create(name: "室内设计", status: 2)
Domain.create(name: "家具设计", status: 2)
Domain.create(name: "导演", status: 2)
Domain.create(name: "展览设计", status: 2)
Domain.create(name: "工业设计", status: 2)
Domain.create(name: "布景设计", status: 2)
Domain.create(name: "广告", status: 2)
Domain.create(name: "建筑", status: 2)
Domain.create(name: "手工艺", status: 2)
Domain.create(name: "排版业", status: 2)
Domain.create(name: "插图", status: 2)
Domain.create(name: "摄影", status: 2)
Domain.create(name: "文案", status: 2)
Domain.create(name: "新闻摄影", status: 2)
Domain.create(name: "时尚行业", status: 2)
Domain.create(name: "景观设计", status: 2)
Domain.create(name: "服装设计", status: 2)
Domain.create(name: "涂鸦艺术", status: 2)
Domain.create(name: "游戏设计", status: 2)
Domain.create(name: "漫画", status: 2)
Domain.create(name: "烹饪艺术", status: 2)
Domain.create(name: "玩具设计", status: 2)
Domain.create(name: "珠宝设计", status: 2)
Domain.create(name: "用户界面/用户体验", status: 2)
Domain.create(name: "电影制作", status: 2)
Domain.create(name: "纺织品设计", status: 2)
Domain.create(name: "绘图", status: 2)
Domain.create(name: "绘画", status: 2)
Domain.create(name: "网站开发", status: 2)
Domain.create(name: "网页设计", status: 2)
Domain.create(name: "美术", status: 2)
Domain.create(name: "艺术指导", status: 2)
Domain.create(name: "视觉效果", status: 2)
Domain.create(name: "计算机动画", status: 2)
Domain.create(name: "雕塑", status: 2)

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
