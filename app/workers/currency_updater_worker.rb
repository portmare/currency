class CurrencyUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(*args)
    rates = ExchangeRate.current_rates
    locales = Hash[rates.keys.map { |x| [x, ExchangeRate.human_attribute_name("currencies.#{x}")] }]

    ActionCable.server.broadcast('currency',
                                 rates: rates,
                                 locales: locales)
  end
end
