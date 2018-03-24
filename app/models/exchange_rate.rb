class ExchangeRate < ApplicationRecord
  enum currency: { usd: 'usd' }

  validates :rate, :expired_at, :currency, presence: true
end
