class ExchangeRate < ApplicationRecord
  enum currency: { usd: 'usd' }

  validates :rate, :expired_at, :currency, presence: true

  scope :active, -> { where('expired_at > ?', Time.zone.now) }
  scope :group_by_currency, -> { where("id IN (#{distinct_on_currency_ids})") }

  def self.current_rates
    CBR::Client.last_curses.deep_merge(
      Hash[active.group_by_currency.map { |x| [x.currency, { rate: x.rate }] }]
    )
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
