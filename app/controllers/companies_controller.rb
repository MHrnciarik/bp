class CompaniesController < ApplicationController
  before_action :require_login

  def new
    @company = current_user.companies.new
  end

  def create
    @company = current_user.companies.new(company_params)

    if @company.save
      redirect_to profiles_path, notice: "Company created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @company = current_user.companies.find(params[:id])
    @company.destroy

    redirect_to profiles_path, notice: "Company deleted successfully."
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
