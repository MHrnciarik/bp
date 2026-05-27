class PasswordsController < ApplicationController
  before_action :set_user_by_token, only: [ :edit, :update ]

  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)
    PasswordsMailer.reset(user).deliver_now if user

    redirect_to login_path, notice: "Ak účet s týmto e-mailom existuje, poslali sme pokyny na obnovu hesla."
  end

  def edit
  end

  def update
    if @user.update(password_params)
      session[:user_id] = nil
      redirect_to login_path, notice: "Heslo bolo zmenené. Prihlás sa novým heslom."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_password_reset_token(params[:token])
    return if @user

    redirect_to new_password_path, alert: "Odkaz na obnovu hesla je neplatný alebo vypršal."
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end
end
