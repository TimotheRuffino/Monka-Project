class QuotesController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :find_quote, only: [:show, :edit, :update, :destroy]

  def index
    @quote_table = current_user.quotes.all
    @quotes = current_user.quotes.where(is_invoice: false)
    @invoices = current_user.quotes.where(is_invoice: true)
  end

  def show
    @goods = @quote.goods
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = Quote.create
  end

  def edit
  end

  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: 'Le client a été mis à jour avec succès.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end
end

def destroy
  @quote.destroy
end

def change_quotes_into_invoices
  @quotes = current_user.quotes.where(is_invoice: false)
  if params[:action] === true
    @quotes.update(quote)

  end

end

private

def find_quote
  @quote = Quote.find(params[:id])
end

def quote_params
  params.fetch(:quote, {}).permit(
    :is_invoice
  )
end


