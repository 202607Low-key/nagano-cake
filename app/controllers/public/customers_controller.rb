class Public::CustomersController < Public::ApplicationController
  def show
    @customer = Current.customer
  end

  def edit
    @customer = Current.customer
  end

  def update
    @customer = Current.customer
    if @customer.update(customer_params)
      redirect_to customers_my_page_path, notice: "会員情報を更新しました。"
    else
      render :edit
    end
  end

  def unsubscribe
    @customer = Current.customer
  end

  def withdraw
    @customer = Current.customer
    if @customer.update(is_active: false)
      terminate_session
      redirect_to root_path, notice: "退会処理が完了しました。"
    else
      render :unsubscribe, alert: "退会処理に失敗しました。"
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:email_address, :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number)
  end
end
