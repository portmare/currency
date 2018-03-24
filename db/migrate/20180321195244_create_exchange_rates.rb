class CreateExchangeRates < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_rates do |t|
      t.string :currency, null: false, index: true
      t.decimal :rate, null: false
      t.datetime :expired_at, null: false

      t.timestamps
    end
  end
end
