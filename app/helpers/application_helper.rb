module ApplicationHelper
  def current_currencies
    ExchangeRate.current_rates.values.to_json
  end
end
