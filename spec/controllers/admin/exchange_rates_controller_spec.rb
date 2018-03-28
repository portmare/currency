require 'rails_helper'

RSpec.describe Admin::ExchangeRatesController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    it 'return http status success' do
      expect(subject).to have_http_status(:ok)
    end

    it 'render index template' do
      expect(subject).to render_template :index
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      subject { post :create, params: { exchange_rate: attributes_for(:exchange_rate) } }

      it 'create new ExchangeRate' do
        expect { subject }.to change { ExchangeRate.count }.by(1)
      end

      it 'return success status' do
        expect(subject).to have_http_status(:ok)
      end

      it 'start CurrencyUpdaterWorker now' do
        expect { subject }.to change { CurrencyUpdaterWorker.jobs.size }.by(1)
      end
    end

    context 'with invalid params' do
      subject { post :create, params: { exchange_rate: attributes_for(:exchange_rate, rate: -1) } }

      it 'do not create new ExchangeRate' do
        expect { subject }.to change { ExchangeRate.count }.by(0)
      end

      it 'return unprocessable_entity status' do
        expect(subject).to have_http_status(:unprocessable_entity)
      end

      it 'do not start CurrencyUpdaterWorker now' do
        expect { subject }.to change { CurrencyUpdaterWorker.jobs.size }.by(0)
      end
    end
  end
end
