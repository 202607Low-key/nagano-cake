class PasswordsMailer < ApplicationMailer
  def reset(customer)
    @customer = customer
    mail subject: "Reset your password", to: customer.email_address
  end
end
