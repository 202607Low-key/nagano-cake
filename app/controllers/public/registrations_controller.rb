module Public
  class RegistrationsController < ApplicationController
    allow_unauthenticated_access only: %i[ new create ]
    def new
      @customer = Customer.new
    end

    def create
      @customer = Customer.new(customer_params)
      if @customer.save
        redirect_to root_path, notice: 'アカウントが作成されました。'
      else
        render :new
      end
    end

    private

    def customer_params
      params.require(:customer).permit(:email_address, :password, :password_confirmation, :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number)
    end
  end
end