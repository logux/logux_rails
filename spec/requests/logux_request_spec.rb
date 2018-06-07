# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logux request', type: :request do
  subject do
    post('/logux',
         params: [['action', { type: 'comment/add' }]],
         as: :json)
  end

  it 'works' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
