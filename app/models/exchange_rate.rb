class ExchangeRate < ApplicationRecord
  enum currency: { usd: 'usd' }

  validates :rate, :expired_at, :currency, presence: true

  scope :active, -> { where('expired_at > ?', Time.zone.now) }
  scope :group_by_currency, -> { where("id IN (#{distinct_on_currency_ids})") }

  def self.current_rates
    rates = CBR::Client.last_curses.slice(*currencies.keys).deep_merge(latest_rates_hash)
    localize_rates(rates)
  end

  def self.default_rates
    latest_rates = group_by_currency.as_json(only: %i[currency rate expired_at])
    options = { currency: nil, rate: nil, expired_at: nil }.stringify_keys
    currencies.keys.map do |cur|
      latest_rates.find { |r| r['currency'] == cur } || options.merge('currency' => cur)
    end
  end

  private

  def self.latest_rates_hash
    Hash[
      active.group_by_currency.map do |x|
        [x.currency, {currency: x.currency, rate: x.rate}]
      end
    ]
  end

  def self.localize_rates(hash)
    hash.transform_values { |x| x.merge(locale: human_attribute_name("currencies.#{x['currency']}")) }
  end

  def self.distinct_on_currency_ids
    inner_sql = arel_table.where(arel_table[:currency].eq(Arel::Table.new("t")[:currency])).order(arel_table[:id].desc).take(1).project(Arel.star).to_sql

    <<-SQL
      WITH RECURSIVE t AS (
        (#{select('min(currency) AS currency').to_sql})
        UNION ALL
        SELECT (#{select('min(currency) AS currency').where('currency > t.currency').to_sql}) AS currency FROM t WHERE t.currency IS NOT NULL
      )

      #{select(:id).from("t, LATERAL (#{inner_sql}) AS #{table_name}").where('t.currency IS NOT NULL').to_sql}
    SQL
  end
end
