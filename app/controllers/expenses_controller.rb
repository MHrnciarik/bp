class ExpensesController < ApplicationController
  before_action :set_expense, only: [ :show, :edit, :update, :destroy ]
  before_action :require_login

  def index
    @vendors = Expense.where.not(vendor: [ nil, "" ]).distinct.order(:vendor).pluck(:vendor)

    @expenses = Expense.all
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
    @expense = Expense.new(date: Date.current, currency: "EUR", tax_rate: 23)
    build_expense_item
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
       redirect_to expenses_path, notice: "Expense was successfully created!"
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
      redirect_to expenses_path, notice: "Expense was successfully updated!"
    else
      build_expense_item
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Expense was successfully deleted!"
  end

  private
  def expense_params
    params.require(:expense).permit(
      :date,
      :currency,
      :tax_rate,
      :vendor,
      :category,
      :payment_method,
      :note,
      expense_items_attributes: [ :id, :name, :quantity, :unit_price, :_destroy ]
    )
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def build_expense_item
    return if @expense.expense_items.reject(&:marked_for_destruction?).any?

    @expense.expense_items.build(quantity: 1)
  end
end
