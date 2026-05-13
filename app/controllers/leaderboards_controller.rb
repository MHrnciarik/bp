class LeaderboardsController < ApplicationController
  before_action :require_login

  def index
    @users = User.order(xp: :desc, username: :asc)
  end
end
