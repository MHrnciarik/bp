class ExpensesController < ApplicationController
  before_action :require_login
  before_action :require_current_company
  before_action :set_expense, only: [ :show, :edit, :update, :destroy ]
  before_action :set_vendors, only: [ :new, :create, :edit, :update ]

  def index
    company_expenses = current_company.expenses
    @vendors = company_expenses.where.not(vendor: [ nil, "" ]).distinct.order(:vendor).pluck(:vendor)

    @expenses = company_expenses
    @expenses = @expenses.by_vendor(params[:vendor])
    @expenses = @expenses.by_category(params[:category])
    @expenses = @expenses.by_payment_method(params[:payment_method])
    @expenses = @expenses.by_currency(params[:currency])
    @expenses = @expenses.by_date_range(params[:start_date], params[:end_date])
    @expenses = @expenses.by_min_amount(params[:min_amount])
    @expenses = @expenses.by_max_amount(params[:max_amount])
    @expenses = @expenses.recent
  end

  def show
  end

  def new
    @expense = current_company.expenses.new(date: Date.current, currency: "EUR")
    build_expense_item
  end

  def create
    @expense = current_company.expenses.new(expense_params)
    if @expense.save
       MissionTracker.track_expense_logged(current_user)
       MissionTracker.track_expense_with_saved_vendor(current_user) if @expense.vendor_record.present?
       MissionTracker.track_expense_categorized(current_user) if @expense.category.present?
       flash_achievements(AchievementTracker.award_new!(current_user))
       redirect_to expenses_path, notice: "Výdavok bol vytvorený."
    else
      build_expense_item
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_expense_item
  end

  def update
    if @expense.update(expense_params)
      if @expense.saved_change_to_category? && @expense.category.present? && @expense.category_before_last_save.blank?
        MissionTracker.track_expense_categorized(current_user)
      end
      redirect_to expenses_path, notice: "Výdavok bol upravený."
    else
      build_expense_item
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Výdavok bol vymazaný."
  end

  private
  def expense_params
    params.require(:expense).permit(
      :date,
      :currency,
      :vendor_id,
      :vendor_entry_mode,
      :vendor_kind,
      :vendor,
      :vendor_first_name,
      :vendor_last_name,
      :vendor_ico,
      :vendor_dic,
      :vendor_ic_dph,
      :vendor_street,
      :vendor_city,
      :vendor_postal_code,
      :vendor_country,
      :category,
      :payment_method,
      :note,
      expense_items_attributes: [ :id, :name, :quantity, :unit_price, :tax_rate, :_destroy ]
    )
  end

  def set_expense
    @expense = current_company.expenses.find(params[:id])
  end

  def set_vendors
    @saved_vendors = current_company.vendors.alphabetical
  end

  def build_expense_item
    return if @expense.expense_items.reject(&:marked_for_destruction?).any?

    @expense.expense_items.build(quantity: 1, tax_rate: 23)
  end
end
