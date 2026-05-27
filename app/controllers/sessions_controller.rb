class SessionsController < ApplicationController
  def new
  end

  def create
    @email = params[:email].to_s.strip.downcase
    user = User.find_by(email: @email)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      LoginStreakTracker.track!(user)
      MissionTracker.track_login(user)
      flash_achievements(AchievementTracker.track_login!(user))
      redirect_to root_path, notice: "Prihlásenie prebehlo úspešne."
    else
      flash.now[:alert] = "Neplatný e-mail alebo heslo."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Odhlásenie prebehlo úspešne."
  end
end
