class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details, dependent: :destroy

  enum :payment_method, { credit_card:0, transfer: 1 }
  enum :status, { pending_payment: 0, payment_confirmed: 1, in_production: 2, preparing_shipment: 3, shipped: 4 }

  paginates_per 10

  after_update :update_order_details_status, if: :saved_change_to_status?

  private

  def update_order_details_status
    if payment_confirmed?
      order_details.where(making_status: :not_startable).update_all(making_status: OrderDetail.making_statuses[:waiting_to_make])
    end
  end

end
