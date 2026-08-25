# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Admin.find_or_create_by!(email_address: "admin@example.com") do |admin|
  admin.password = "admin"
end

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

customers = Customer.all
items = Item.where(is_active: true)

11.times do |i|
  customer = customers[i % customers.count]

  order = Order.find_or_create_by!(customer: customer, name: "#{customer.first_name} #{customer.last_name}") do |o|
    o.postal_code = customer.postal_code
    o.address = customer.address
    o.payment_method = i.even? ? :credit_card : :transfer
    o.status = Order.statuses.keys[i % Order.statuses.size]
    o.shipping_cost = 800
    o.total_payment = 0 # 後で計算して更新
  end

  # 注文明細(1〜3商品をランダムに割り当て)
  next if order.order_details.exists?

  selected_items = items.sample(rand(1..3))
  total = 0

  selected_items.each do |item|
    quantity = rand(1..5)
    price = (item.price * 1.1).floor
    OrderDetail.create!(
      order: order,
      item: item,
      price: price,
      amount: quantity,
      making_status: OrderDetail.making_statuses.keys[i % OrderDetail.making_statuses.size]
    )
    total += price * quantity
  end

  order.update!(total_payment: total + order.shipping_cost)
end

sample_addresses = [
  { postal_code: "244-0812", address: "神奈川県横浜市戸塚区柏尾町3-9-10", name: "梅木匠" },
  { postal_code: "400-1114", address: "山梨県甲斐市打返4-5-19", name: "小沢時男" },
  { postal_code: "160-0022", address: "東京都新宿区新宿2-5-10成信ビル4階", name: "鈴木太郎" }
]

customers.each_with_index do |customer, i|
  sample = sample_addresses[i % sample_addresses.size]

  Address.find_or_create_by!(customer: customer, postal_code: sample[:postal_code], address: sample[:address]) do |addr|
    addr.name = sample[:name]
  end
end