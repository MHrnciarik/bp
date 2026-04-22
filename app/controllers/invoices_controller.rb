class InvoicesController < ApplicationController
  before_action :require_login
  before_action :require_current_company
  before_action :set_invoice, only: [ :show, :edit, :update, :destroy ]

  def index
    company_invoices = current_company.invoices
    @clients = company_invoices.where.not(client_name: [ nil, "" ]).distinct.order(:client_name).pluck(:client_name)

    @invoices = company_invoices
    @invoices = @invoices.by_client_name(params[:client_name])
    @invoices = @invoices.by_status_filter(params[:status])
    @invoices = @invoices.by_issued_on_range(params[:issued_start_date], params[:issued_end_date])
    @invoices = @invoices.by_due_on_range(params[:due_start_date], params[:due_end_date])
    @invoices = @invoices.by_min_amount(params[:min_amount])
    @invoices = @invoices.by_max_amount(params[:max_amount])
    @invoices = @invoices.recent
  end

  def show
  end

  def new
    @invoice = current_company.invoices.new(issued_on: Date.current, due_on: Date.current, currency: "EUR", status: "unpaid", tax_rate: 23)
    build_invoice_item
  end

  def create
    @invoice = current_company.invoices.new(invoice_params)

    if @invoice.save
      MissionTracker.track_invoice_created(current_user)
      redirect_to @invoice, notice: "Invoice created!"
    else
      build_invoice_item
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice, notice: "Invoice updated!"
    else
      build_invoice_item
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    build_invoice_item
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_path, notice: "Invoice deleted!"
  end

  private
  def set_invoice
    @invoice = current_company.invoices.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(
      :issued_on,
      :due_on,
      :status,
      :currency,
      :tax_rate,
      :client_name,
      :client_address,
      :note,
      invoice_items_attributes: [ :id, :name, :quantity, :unit_price, :_destroy ]
    )
  end

  def build_invoice_item
    return if @invoice.invoice_items.reject(&:marked_for_destruction?).any?

    @invoice.invoice_items.build(quantity: 1)
  end
end
