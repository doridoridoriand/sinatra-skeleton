require 'spec_helper'

RSpec.describe 'GET /dashboard' do
  it 'returns 200 OK' do
    get '/dashboard'
    expect(last_response).to be_ok
  end
  
  it 'displays dashboard title' do
    get '/dashboard'
    expect(last_response.body).to include('Dashboard')
  end
end
