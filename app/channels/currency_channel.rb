class CurrencyChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'currency'
    CurrencyUpdaterWorker.perform_at(0)
  end

  def unsubscribed
    stop_all_streams
  end
end
