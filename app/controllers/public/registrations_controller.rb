class Public::RegistrationsController < Public::ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      start_new_session_for @customer
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:email_address, :password, :password_confirmation)
  end
end
