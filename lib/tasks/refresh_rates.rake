require_relative '../../app/workers/currency_updater_worker'

namespace :currency do
  desc 'Refresh currencies rates'
  task refresh_rates: :environment do
    CurrencyUpdaterWorker.perform_async
  end
end
