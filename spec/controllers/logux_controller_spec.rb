require 'rails_helper'

RSpec.describe LoguxController, type: :controller do
  subject { post(:create, params: { events: ['action', { type: 'a' }] }) }

  it 'works' do
    expect(subject).to have_http_status(:ok)
  end
end
