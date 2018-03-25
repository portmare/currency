require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  context 'validation' do
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

  context 'class methods' do
    context 'active' do
      before :each do
        create(:exchange_rate, expired_at: Time.now - 1.seconds)
      end

      it 'return array of exchange rates with expired_at > Time.now' do
        exchange_rate = create(:exchange_rate)
        expect(described_class.active).to match_array([exchange_rate])
      end

      it 'return empty array with expired_at < Time.now' do
        expect(described_class.active).to eq []
      end
    end

    context 'group_by_currency' do
      before :each do
        create_list(:exchange_rate, 5)
      end

      it 'return last rates for each currency' do
        rate_usd = create(:exchange_rate, rate: 10_000)
        expect(described_class.group_by_currency).to match_array([rate_usd])
      end
    end

    context 'current_rates' do
      it 'return CBR rate for USD with expired_at < Time.now' do
        create(:exchange_rate, expired_at: Time.now - 1.seconds, rate: 10_000)
        expect(described_class.current_rates[:usd][:rate]).not_to eq 10_000
      end

      it 'return DB rate for USD with expired_at > Time.now' do
        create(:exchange_rate, rate: 10_000)
        expect(described_class.current_rates[:usd][:rate]).to eq 10_000
      end
    end
  end
end
