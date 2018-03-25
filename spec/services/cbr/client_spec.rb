require 'rails_helper'

describe CBR::Client do
  let(:client) { CBR::Client.new }
  let(:current_date) { Time.new(2018, 3, 18) }

  context 'get curs on date' do
    subject { client.get_curs_on_date(current_date) }

    it 'return array' do
      expect(subject).to be_instance_of(Array)
    end

    it 'return list of exchange rates for a certain date' do
      expect(subject.map { |x| x[:vch_code] }).to include('USD', 'GBP', 'EUR')
    end
  end

  context 'get latest curs of USD' do
    subject { CBR::Client.last_curs('USD')[:rate] }

    it 'return real number is greather than 0' do
      expect(subject).to be > 0.0
    end

    it 'return 57.4942 on date 18.03.2018' do
      allow(Time).to receive(:now).and_return(current_date)
      expect(subject).to eq 57.4942
    end
  end
end
