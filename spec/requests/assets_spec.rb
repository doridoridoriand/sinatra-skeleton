require 'spec_helper'

RSpec.describe 'GET /css/application.css' do
  it 'returns CSS content' do
    get '/css/application.css'
    expect(last_response).to be_ok
    expect(last_response.content_type).to include('text/css')
  end
end
