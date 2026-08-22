class Public::SessionsController < Public::ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :customer_state, only: %i[ create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    redirect_to root_path if authenticated_customer?
  end

  def create
    if customer = Customer.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for customer
      redirect_to after_authentication_url
    else
      redirect_to customers_sign_in_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to customers_sign_in_path
  end

  private

  def customer_state
    customer = Customer.find_by(email_address: params[:email_address])
    return if customer.nil?
    return unless customer.authenticate(params[:password])
    redirect_to customers_sign_up_path unless customer.is_active
  end
end
