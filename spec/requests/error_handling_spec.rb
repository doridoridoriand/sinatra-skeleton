require 'spec_helper'

RSpec.describe 'Error handling' do
  it 'renders custom 404 page' do
    get '/no-such-path'
    expect(last_response.status).to eq(404)
    expect(last_response.body).to include('ページが見つかりません')
  end

  it 'renders custom 500 page via error handler' do
    get '/__spec__/trigger_error'
    expect(last_response.status).to eq(500)
    expect(last_response.body).to include('エラーが発生しました')
  end

  it 'handles CSRF token errors with 403 response' do
    get '/__spec__/trigger_csrf_error'
    expect(last_response.status).to eq(403)
    expect(last_response.body).to include('不正なリクエスト')
  end
end
