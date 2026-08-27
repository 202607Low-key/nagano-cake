class Public::PasswordsController < Public::ApplicationController
  allow_unauthenticated_access
  before_action :set_customer_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if customer = Customer.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(customer).deliver_later
    end

    redirect_to customers_sign_in_path, notice: "パスワード再設定用のメールを送信しました。"
  end

  def edit
  end

  def update
    if @customer.update(params.permit(:password, :password_confirmation))
      redirect_to customers_sign_in_path, notice: "パスワードを再設定しました。"
    else
      redirect_to edit_password_path(params[:token]), alert: "パスワードが一致しませんでした。"
    end
  end

  private
    def set_customer_by_token
      @customer = Customer.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "パスワード再設定用のリンクが無効か、有効期限が切れています。"
    end
end
