require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    it 'return success status' do
      expect(subject).to have_http_status(:ok)
    end

    it 'render index template' do
      expect(subject).to render_template :index
    end
  end
end
