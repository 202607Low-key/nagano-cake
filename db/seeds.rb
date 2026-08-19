# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
11.times do |i|
  Customer.find_or_create_by!(email_address: "customer#{i + 1}@example.com") do |customer|
    customer.password = "password123"
    customer.last_name = Faker::Name.last_name
    customer.first_name = Faker::Name.first_name
    customer.last_name_kana = "テスト"
    customer.first_name_kana = "コキャク"
    customer.postal_code = Faker::Address.zip_code
    customer.address = Faker::Address.full_address
    customer.telephone_number = "0368694700"
    customer.is_active = true
  end
end