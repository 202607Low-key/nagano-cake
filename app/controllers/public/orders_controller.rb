module Public
  class OrdersController < Public::ApplicationController
    def new
      @cart_items = current_customer.cart_items.includes(:item)
      if @cart_items.empty?
        redirect_to cart_items_path, alert: "カートが空です"
        return
      end

      @order = Order.new
      @addresses = current_customer.addresses
    end

    def confirm
      if request.post?
        delivery_info = build_delivery_info
        if delivery_info.nil?
          redirect_to new_order_path, alert: "お届け先情報が正しくありません"
          return
        end

        session[:order_info] = {
          payment_method: params[:order][:payment_method],
          postal_code: delivery_info[:postal_code],
          address: delivery_info[:address],
          name: delivery_info[:name]
        }

        redirect_to confirm_orders_path
        return
      end

      order_info = session[:order_info]
      if order_info.blank?
        redirect_to new_order_path, alert: "注文情報が見つかりません"
        return
      end

      @cart_items = current_customer.cart_items.includes(:item)
      if @cart_items.empty?
        redirect_to cart_items_path, alert: "カートが空です"
        return
      end

      @order = Order.new(order_info)
      @shipping_cost = 800
      @total_price = @cart_items.sum(&:subtotal)
      @total_payment = @total_price + @shipping_cost
    end

    def complete
    end

    def create
      order_info = session[:order_info]
      if order_info.blank?
        redirect_to new_order_path, alert: "注文情報が見つかりません"
        return
      end

      @cart_items = current_customer.cart_items.includes(:item)
      if @cart_items.empty?
        redirect_to cart_items_path, alert: "カートが空です"
        return
      end

      shipping_cost = 800
      total_price = @cart_items.sum(&:subtotal)

      @order = current_customer.orders.new(
        payment_method: order_info["payment_method"],
        postal_code: order_info["postal_code"],
        address: order_info["address"],
        name: order_info["name"],
        status: :pending_payment,
        shipping_cost: shipping_cost,
        total_payment: total_price + shipping_cost
      )

      ActiveRecord::Base.transaction do
        @order.save!

        @cart_items.each do |cart_item|
          OrderDetail.create!(
            order: @order,
            item: cart_item.item,
            price: cart_item.item.with_tax_price,
            amount: cart_item.amount,
            making_status: :not_startable
          )
        end

        @cart_items.destroy_all
      end

      session.delete(:order_info)
      redirect_to complete_orders_path
    rescue ActiveRecord::RecordInvalid
      redirect_to new_order_path, alert: "注文の作成に失敗しました"
    end

    def index
      @orders = current_customer.orders.order(created_at: :desc).page(params[:page])
    end

    def show
      @order = current_customer.orders.find(params[:id])
    end

    private

    def build_delivery_info
      case params[:delivery_type]
      when "my_address"
        {
          postal_code: current_customer.postal_code,
          address: current_customer.address,
          name: "#{current_customer.last_name} #{current_customer.first_name}"
        }
      when "registered_address"
        selected = current_customer.addresses.find_by(id: params[:address_id])
        return nil unless selected
        { postal_code: selected.postal_code, address: selected.address, name: selected.name }
      when "new_address"
        postal_code = params[:order][:postal_code]
        address = params[:order][:address]
        name = params[:order][:name]
        return nil if postal_code.blank? || address.blank? || name.blank?
        { postal_code: postal_code, address: address, name: name}
      else
        nil
      end
    end

    def order_params
      params.require(:order).permit(:payment_method, :postal_code, :address, :name)
    end
  end
end