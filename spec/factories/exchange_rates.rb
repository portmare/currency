FactoryBot.define do
  factory :exchange_rate do
    currency "usd"
    rate "9.99"
    expired_at Time.now + 1.day
  end
end
