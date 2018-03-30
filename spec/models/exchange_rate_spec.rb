require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  context 'validation' do
    it 'is valid with currency, rate and expired_at' do
      exchange_rate = build(:exchange_rate)
      expect(exchange_rate).to be_valid
    end

    it 'is valid with rate > 0' do
      exchange_rate = build(:exchange_rate, rate: 0.01)
      expect(exchange_rate).to be_valid
    end

    it 'is valid with expired_at > Time.now' do
      exchange_rate = build(:exchange_rate, expired_at: Time.now + 1.minutes)
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

    it 'is not valid with rate < 0' do
      exchange_rate = build(:exchange_rate, rate: -0.01)
      expect(exchange_rate).to be_invalid
    end

    it 'is not valid with rate == 0' do
      exchange_rate = build(:exchange_rate, rate: 0)
      expect(exchange_rate).to be_invalid
    end

    it 'is not valid with expired_at < Time.now' do
      exchange_rate = build(:exchange_rate, expired_at: Time.now - 1.second)
      expect(exchange_rate).to be_invalid
    end

    it 'is not valid with expired_at == Time.now' do
      exchange_rate = build(:exchange_rate, expired_at: Time.now)
      expect(exchange_rate).to be_invalid
    end
  end

  context 'class methods' do
    context 'active' do
      before :each do
        create(:exchange_rate, :skip_validation, expired_at: Time.now - 1.seconds)
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
        create(:exchange_rate, :skip_validation, expired_at: Time.now - 1.seconds, rate: 10_000)
        expect(described_class.current_rates[:usd][:rate]).not_to eq 10_000
      end

      it 'return DB rate for USD with expired_at > Time.now' do
        create(:exchange_rate, rate: 10_000)
        expect(described_class.current_rates[:usd][:rate]).to eq 10_000
      end
    end

    context 'default_rates' do
      it 'return list with default rate with no DB rate' do
        expect(described_class.default_rates.first).not_to be_nil
      end

      it 'return list with exists DB rates' do
        exchange_rate = create(:exchange_rate)
        expect(described_class.default_rates.first['rate']).to eq exchange_rate.rate
      end
    end

    context 'latest_rates_hash' do
      before :each do
        create_list(:exchange_rate, 5)
      end

      it 'return empty hash of rates if there are no active' do
        create(:exchange_rate, :skip_validation, expired_at: Time.now - 1.seconds)
        expect(described_class.latest_rates_hash).to eq({})
      end

      it 'return hash with latest active rates' do
        expect(described_class.latest_rates_hash).not_to eq({})
      end
    end
  end
end
