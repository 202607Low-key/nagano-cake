class Customer < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :cart_items, dependent: :destroy
  has_many :orders
  has_many :addresses, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true, format: { with: /\A[ァ-ヶー]+\z/, message: "はカタカナで入力してください", allow_blank: true }
  validates :first_name_kana, presence: true, format: { with: /\A[ァ-ヶー]+\z/, message: "はカタカナで入力してください", allow_blank: true }
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :telephone_number, presence: true
end
