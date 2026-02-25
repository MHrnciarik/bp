class ExpensesController < ApplicationController
  before_action :set_expense, only: [ :show, :edit, :update, :destroy ]
  def index
    @expenses = Expense.all
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
    @expense = Expense.new(date: Date.current, currency: "EUR", amount: 0)
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
       redirect_to expenses_path, notice: "Expense was successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "Expense was successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Expense was successfully deleted!"
  end

  private
  def expense_params
    params.require(:expense).permit(:date, :amount, :currency, :vendor, :category, :payment_method, :note)
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end
end
