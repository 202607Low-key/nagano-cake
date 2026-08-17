class Public::AddressesController < ApplicationController
  def index
    @addresses = Current.customer.addresses
  end

  def edit
    @address = Current.customer.addresses.find(params[:id])
  end

  def create
    @address = Current.customer.addresses.new(address_params)
    if @address.save
      redirect_to addresses_path
    else
      render :index
    end
  end

  def update
    @address = Current.customer.addresses.find(params[:id])
    if @address.update(address_params)
      redirect_to addresses_path
    else
      render :edit
    end
  end

  def destroy
    @address = Current.customer.addresses.find(params[:id])
    @address.destroy
    redirect_to addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:postal_code, :address, :name)
  end
  
end
