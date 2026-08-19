class Public::ItemsController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]
  def index
    @items = Item.includes(:genre).page(params[:page]).where(is_active: true)
  end

  def show
    @item = Item.find(params[:id])
  end
end
