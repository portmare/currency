class ExchangeRate < ApplicationRecord
  enum currency: { usd: 'usd' }

  validates :rate, :expired_at, :currency, presence: true

  scope :active, -> { where('expired_at > ?', Time.zone.now) }
  scope :group_by_currency, -> { select('DISTINCT ON (currency) id, currency, rate').order(currency: :desc, id: :desc) }

  def self.current_rates
    CBR::Client.last_curses.deep_merge(
      Hash[active.group_by_currency.map { |x| [x.currency, { rate: x.rate }] }]
    )
  end
end
