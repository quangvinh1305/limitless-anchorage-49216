# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#   
User.destroy_all
Category.destroy_all
Product.destroy_all
User.create!(name:  "Example User",
             email: "quangvinh.1305@gmail.com",
             adress: "15/14 Vo Duy Ninh Street",
             phone_number: "0987556556",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              adress: "15/14 Vo Duy Ninh Street",
              phone_number: "0987556556",
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end



n = 0;
User.all.each {|u| u.microposts.create!(content: 'Micropost #{n++} ') }


Category::CATEGORIES.each do |category, br_node|
  Category.create(title: category)
  puts "#{category} is created"
end


amazon = AmazonProduct.new
amazon.create_amz_products

    