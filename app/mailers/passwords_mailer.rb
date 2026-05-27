class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user

    mail to: @user.email, subject: "Obnova hesla"
  end
end
