class QuotesController < ApplicationController
  include ApplicationHelper

  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  def index
    @quote_table = current_user.quotes.all
    @quotes = current_user.quotes.where(is_invoice: false)
    @invoices = current_user.quotes.where(is_invoice: true)
  end

  def show
    @goods = @quote.goods.all
  end

  def new
    @quote = Quote.new
    @quote.goods.build
  end

  def edit
  end

  def create
    @quote = Quote.new(quote_params)

    # Get a Quote object with data selected by the user and allocated on wether
    # he has choosen to create a quote or an invoice
    @quote = save_quote_in_db(@quote)

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: 'Le devis ou la facture a bien été créé.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: 'Le devis ou la facture a bien été mise à jour.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url, notice: 'Le devis ou la facture a bien été supprimé.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_quote
    @quote = Quote.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def quote_params
    params.require(:quote).permit(
        :quote_number,
        :invoice_number,
        :amount,
        :discount,
        :quote_sending_date,
        :invoice_sending_date,
        :quote_sending_counter,
        :invoice_sending_counter,
        :is_invoice,
        :is_paid,
        :user_id,
        :customer_id,
        goods_attributes: [:id, :title, :description, :quantity, :price, :user_id],
        )
  end
end

# Get a Quote object with data selected by the user and allocated on wether
# he has choosen to create a quote or an invoice
def save_quote_in_db(quote)
  # Allocate the current user creating the quote
  quote.user = current_user

  # By default, allocate a discount to 0
  # TODO : Code a bonus feature allowing to add a discount to a quote
  quote.discount = 0

  # Allocate a quote_number or an invoice_invoice depending on user's choice
  quote_or_invoice_number = "#{current_user.first_name[0]}#{current_user.last_name[0]}#{DateTime.now.strftime("%d%m%Y%H%M")}"

  if quote.is_invoice === false
    quote.quote_number = quote_or_invoice_number
  else
    quote.invoice_number = quote_or_invoice_number
  end

  # Allocate goods to the quotes
  if params[:quote][:goods]
    quote_amount = 0

    params[:quote][:goods].each do |good|
      good if good.empty? === false
      if good.empty? === false
        curent_good = Good.find(good)

        # insert good into the list of goods
        quote.goods << curent_good

        # Line used to calculate total price of all goods
        quote_amount += curent_good.price * curent_good.quantity
      end
    end

    quote.amount = quote_amount
  end

  quote
end
