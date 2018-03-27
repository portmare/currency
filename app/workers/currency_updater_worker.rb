class CurrencyUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(*args)
    ActionCable.server.broadcast('currency', rates: ExchangeRate.current_rates.values)
  end
end
