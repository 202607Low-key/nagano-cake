class Admin::OrderDetailsController < Admin::ApplicationController
  def update
    @order_detail = OrderDetail.find(params[:id])
    if @order_detail.update(order_detail_params)
      redirect_to admin_order_path(@order_detail.order), notice: "製作ステータスを更新しました。"
    else
      redirect_to admin_order_path(@order_detail.order), alert: "更新に失敗しました。"
    end
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
end
