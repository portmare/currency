class Admin::ExchangeRatesController < ApplicationController
  def index
    @rates = ExchangeRate.default_rates
  end

  def create
    rate = ExchangeRate.new(exchange_rate_params)
    if rate.save
      CurrencyUpdaterWorker.new.perform
      render json: { rate: rate }, status: :ok
    else
      render json: { errors: rate.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def exchange_rate_params
    params.require(:exchange_rate).permit(:currency, :rate, :expired_at)
  end
end
