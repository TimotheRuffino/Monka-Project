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
    @quote = Quote.find(params[:id])
    respond_to do |format|
      format.pdf {
        send_data @quote.receipt.render,
                  filename: "#{@quote.created_at.strftime("%Y-%m-%d")}-gorails-receipt.pdf",
                  type: "application/pdf",
                  disposition: :inline
      }
    end
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
    @quote.update
  end

  def destroy
    @quote.destroy
    flash[:error] = "L'élément a bien été supprimé"
    redirect_to :quotes
  end

  private

  def find_quote
    @quote = Quote.find(params[:id])
  end


end
