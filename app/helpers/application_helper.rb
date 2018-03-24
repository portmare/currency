module ApplicationHelper
  def current_currencies
    ExchangeRate.currencies.keys.map { |x| {'name': x} }.to_json
  end
end
