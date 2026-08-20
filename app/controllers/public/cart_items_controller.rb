class Public::CartItemsController < ApplicationController
  def index
    @cart_items = Current.customer.cart_items
    @total_price = 0
  end

  def create
    @cart_item = Current.customer.cart_items.new(cart_item_params)
    existing_cart_item = Current.customer.cart_items.find_by(item_id: cart_item_params[:item_id])

    if existing_cart_item
      existing_cart_item.update(amount: existing_cart_item.amount + cart_item_params[:amount])
    else
      @cart_item.save
    end

    redirect_to cart_items_path
  end

  def update
  end

  def destroy
  end

  def all_destroy
  end

  private
    def cart_item_params
      params.require(:cart_item).permit(:item_id, :amount)
    end
end
