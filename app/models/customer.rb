class Customer < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :addresss, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
