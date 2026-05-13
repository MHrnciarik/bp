class CompaniesController < ApplicationController
  before_action :require_login

  def new
    @company = current_user.companies.new
  end

  def create
    @company = current_user.companies.new(company_params)

    if @company.save
      session[:current_company_id] ||= @company.id
      flash_achievements(AchievementTracker.award_new!(current_user))
      redirect_to profiles_path, notice: "Firma bola vytvorená."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def select
    @company = current_user.companies.find(params[:id])
    session[:current_company_id] = @company.id

    redirect_back fallback_location: profiles_path, notice: "Prepnuté na firmu #{@company.name}."
  end

  def destroy
    @company = current_user.companies.find(params[:id])
    @company.destroy
    session[:current_company_id] = current_user.companies.order(:created_at, :id).first&.id if session[:current_company_id].to_i == @company.id

    redirect_to profiles_path, notice: "Firma bola vymazaná."
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :ico,
      :dic,
      :ic_dph,
      :street,
      :city,
      :postal_code,
      :country
    )
  end
end
