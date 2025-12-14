require 'spec_helper'

RSpec.describe 'Bootstrap 5 Migration' do
  describe 'GET /' do
    before { get '/' }
    
    it 'includes Bootstrap 5 CSS from CDN' do
      expect(last_response.body).to include('bootstrap@5.3.3/dist/css/bootstrap.min.css')
    end
    
    it 'includes Bootstrap 5 JS from CDN' do
      expect(last_response.body).to include('bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js')
    end
    
    it 'does not include bootstrap_assets helper' do
      expect(last_response.body).not_to include('bootstrap_assets')
    end
    
    it 'uses Bootstrap 5 grid classes' do
      expect(last_response.body).to include('col-12')
    end
    
    it 'does not use old Bootstrap 3 grid classes' do
      expect(last_response.body).not_to include('row-fluid')
      expect(last_response.body).not_to include('span12')
    end
  end
  
  describe 'GET /dashboard' do
    before { get '/dashboard' }
    
    it 'includes Bootstrap 5 CSS from CDN' do
      expect(last_response.body).to include('bootstrap@5.3.3/dist/css/bootstrap.min.css')
    end
    
    it 'uses Bootstrap 5 grid classes' do
      expect(last_response.body).to include('col-12')
    end
  end
end
