class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      MissionTracker.track_login(user)
      flash_achievements(AchievementTracker.track_login!(user))
      redirect_to root_path, notice: "Prihlásenie prebehlo úspešne."
    else
      flash.now[:alert] = "Neplatné používateľské meno alebo heslo."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Odhlásenie prebehlo úspešne."
  end
end
