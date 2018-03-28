require 'rails_helper'

RSpec.describe 'Exchange rate managment', type: :request do
  it 'create a new ExchangeRate with valid params' do
    get '/admin'
    expect(response).to render_template :index

    post '/admin', params: { exchange_rate: attributes_for(:exchange_rate) }
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json")
    expect(ExchangeRate.count).to eq 1
  end

  it 'not create ExchangeRate with invalid params' do
    get '/admin'
    expect(response).to render_template :index

    post '/admin', params: { exchange_rate: attributes_for(:exchange_rate, rate: -1) }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.content_type).to eq("application/json")
    expect(ExchangeRate.count).to eq 0
  end
end
