class Public::OrdersController < PublicApplicationController
  def new
  end

  def confirm
  end

  def complete
  end

  def create
  end

  def index
    @order = current.customer.orders.order(created_at: :desc).page(params[:page])
  end

  def show
  end
end
