require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  it 'is valid with currency, rate and expired_at' do
    exchange_rate = build(:exchange_rate)
    expect(exchange_rate).to be_valid
  end

  it 'is not valid without currency' do
    exchange_rate = build(:exchange_rate, currency: nil)
    expect(exchange_rate).to be_invalid
  end

  it 'is not valid without rate' do
    exchange_rate = build(:exchange_rate, rate: nil)
    expect(exchange_rate).to be_invalid
  end

  it 'is not valid without expired_at' do
    exchange_rate = build(:exchange_rate, expired_at: nil)
    expect(exchange_rate).to be_invalid
  end
end
