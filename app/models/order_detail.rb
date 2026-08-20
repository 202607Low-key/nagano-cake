class OrderDetail < ApplicationRecord

  belongs_to :order
  belongs_to :item

  enum :making_status, { not_startable: 0, waiting_to_make: 1, in_production: 2, completed: 3 }

end
