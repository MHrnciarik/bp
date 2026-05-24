class ClientsController < ApplicationController
  before_action :require_login
  before_action :require_current_company
  before_action :set_client, only: [ :show, :edit, :update, :destroy ]

  def index
    @clients = current_company.clients.alphabetical
  end

  def show
  end

  def new
    @client = current_company.clients.new(kind: "company")
  end

  def create
    @client = current_company.clients.new(client_params)

    if @client.save
      flash_achievements(AchievementTracker.award_new!(current_user))
      redirect_to clients_path, notice: "Klient bol vytvorený."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Klient bol upravený."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: "Klient bol vymazaný."
  end

  private

  def set_client
    @client = current_company.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(
      :name,
      :kind,
      :first_name,
      :last_name,
      :ico,
      :dic,
      :ic_dph,
      :street,
      :city,
      :postal_code,
      :country,
      :email,
      :website,
      :phone,
      :address,
      :note
    )
  end
end
