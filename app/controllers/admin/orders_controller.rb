class Admin::OrdersController < Admin::ApplicationController
  def index
    @orders = Order.includes(:customer, :order_details).order(created_at: :desc).page(params[:page])
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "注文ステータスを更新しました。"
    else
      redirect_to admin_order_path(@order), alert: "更新に失敗しました。"
    end
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end
end
