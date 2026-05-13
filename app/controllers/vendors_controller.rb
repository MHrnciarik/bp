class VendorsController < ApplicationController
  before_action :require_login
  before_action :require_current_company
  before_action :set_vendor, only: [ :show, :edit, :update, :destroy ]

  def index
    @vendors = current_company.vendors.alphabetical
  end

  def show
  end

  def new
    @vendor = current_company.vendors.new
  end

  def create
    @vendor = current_company.vendors.new(vendor_params)

    if @vendor.save
      flash_achievements(AchievementTracker.award_new!(current_user))
      redirect_to vendors_path, notice: "Predajca bol vytvorený."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @vendor.update(vendor_params)
      redirect_to @vendor, notice: "Predajca bol upravený."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vendor.destroy
    redirect_to vendors_path, notice: "Predajca bol vymazaný."
  end

  private

  def set_vendor
    @vendor = current_company.vendors.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:name, :address, :note)
  end
end
