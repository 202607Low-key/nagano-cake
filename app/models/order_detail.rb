class OrderDetail < ApplicationRecord

  belongs_to :order
  belongs_to :item

  enum :making_status, { not_startable: 0, waiting_to_make: 1, in_production: 2, completed: 3 }

  after_update :update_order_status, if: :saved_change_to_making_status?

  private

  def update_order_status
    if making_status_in_production? && order.pending_payment?
    end

    if making_status_in_production? && order.payment_confirmed?
      order.update(status: :in_production)
    elsif order.order_details.all? { |od| od.making_status == "completed" }
      order.update(status: :preparing_shipment)
    end
  end

  def making_status_in_production
    making_status == "in_production"
  end

end
