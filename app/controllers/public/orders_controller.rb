module Public
  class OrdersController < Public::ApplicationController
    def new
    end

    def confirm
    end

    def complete
    end

    def create
    end

    def index
      @orders = current_customer.orders.order(created_at: :desc).page(params[:page])
    end

    def show
      @order = current_customer.orders.find(params[:id])
    end
  end
end