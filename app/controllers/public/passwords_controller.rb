class Public::PasswordsController < Public::ApplicationController
  allow_unauthenticated_access
  before_action :set_customer_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if customer = Customer.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(customer).deliver_later
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if customer with that email address exists)."
  end

  def edit
  end

  def update
    if @customer.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "Password has been reset."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private
    def set_customer_by_token
      @customer = Customer.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end
