class InvoicesController < ApplicationController
  before_action :set_invoice, only: [ :show, :edit, :destroy ]

  def index
    @invoices = Invoice.order(created_at: :desc)
  end

  def show
  end

  def new
    @invoice = Invoice.new(issued_on: Date.current, currency: "EUR", status: "unpaid", amount: 0)
  end

  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      redirect_to @invoice, notice: "Invoice created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    set_invoice

    if @invoice.update(invoice_params)
      redirect_to @invoice, notice: "Invoice updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_path, notice: "Invoice deleted!"
  end

  private
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:issued_on, :due_on, :status, :currency, :amount, :number, :client_name, :client_address, :note)
  end
end
