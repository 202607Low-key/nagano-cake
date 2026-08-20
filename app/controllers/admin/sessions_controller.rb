class Admin::SessionsController < Admin::ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_admin_session_url, alert: "後でもう一度お試しください。" }

  def new
    redirect_to admin_root_path if authenticated_admin?
  end

  def create
    if admin = Admin.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for admin
      redirect_to admin_root_path
    else
      redirect_to new_admin_session_path, alert: "メールアドレスまたはパスワードが正しくありません。"
    end
  end

  def destroy
    terminate_session
    redirect_to new_admin_session_path
  end
end