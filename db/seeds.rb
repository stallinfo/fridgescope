# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Administrator.create!(name:  "SBS Admin",
             identify: "sbsadmin",
             password:              "aaaaaaaa",
             password_confirmation: "aaaaaaaa")
Administrator.create!(name:  "SBS Co Admin",
             identify: "sbscoadmin",
             password:              "bbbbbbbb",
             password_confirmation: "bbbbbbbb")
# Generate a bunch of additional users.
#99.times do |n|
#    name = Faker::Name.name
#    identify = "identify-#{n+1}" 
#    password = "password"
#    Administrator.create!(name: name,
#        identify: identify,
#        password:              password,
#        password_confirmation: password)
#end