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
Service.create!(name: "Shizuoka City", connection_phrase: "SZK01", description: "Shizuoka municipality area", update_count: 0, created_by: "sbsadmin", updated_by: "sbsadmin")
ServiceManager.create!(service_id: 1, name: "Suruga Municipality", identify: "suruga", update_count: 0, created_by: "sbsadmin", updated_by: "sbsadmin")
Facility.create!(service_id: 1, name: "Nishiwaki Gathering", latitude: 0.349665851153456e2, longitude: 0.13840189267876e3, created_by: "suruga", update_count: 0, updated_by: "suruga")
FacilityManager.create!(facility_id: 1, identify: "suzuki", password: "suzuki", password_confirmation: "suzuki", name: "Suzuki Taro", email: "suzuki@taro.com", update_count: 0, created_by: "suruga", updated_by: "suruga")
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