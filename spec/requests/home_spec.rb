require 'spec_helper'

RSpec.describe 'GET /' do
  it 'returns 200 OK' do
    get '/'
    expect(last_response).to be_ok
  end
  
  it 'displays welcome title' do
    get '/'
    expect(last_response.body).to include('Welcome')
  end
end
