module ApplicationHelper
  def bootstrap_class_for_flash(type)
    case type
    when 'notice' then "alert-info"
    when 'success' then "alert-success"
    when 'error' then "alert-danger"
    when 'alert' then "alert-warning"
    else
      "alert-info"
    end
  end

  def calculate_total_quote(goods)
    @total_quote = 0

    goods.each do |good|
      @total_quote += good.price * good.quantity
    end

    @total_quote
  end

  def get_annual_turnover(quotes)
    turnover = 0

    quotes.each do |quote|
      turnover += quote.amount
    end

    turnover
  end

  def get_monthly_turnover(invoices)
    turnover = 0

    invoices.each do |invoice|
      if DateTime.now.strftime("%m") === invoice.invoice_sending_date.strftime("%m")
        turnover += invoice.amount
      end
    end

    turnover
  end

  def get_calendar_turnover(invoices, month)
    turnover = 0

    invoices.each do |invoice|
      if month === invoice.invoice_sending_date.strftime("%m")
        turnover += invoice.amount
      end
    end

    turnover
  end

  #Send mail to customer
  def payment_send
    @quote = Quote.find(params[:id])
    QuoteMailer.payment_email(@quote).deliver_now
    flash[:success] = "Votre document a bien été envoyé par mail !"
    redirect_back(fallback_location: quotes_path)
  end
end
