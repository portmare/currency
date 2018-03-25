require 'rails_helper'

RSpec.describe CurrencyUpdaterWorker, type: :worker do
  it 'run async job' do
    expect {
      described_class.perform_async
    }.to change(described_class.jobs, :size).by(1)
  end
end
