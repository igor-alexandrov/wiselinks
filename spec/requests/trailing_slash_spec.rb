require "helper"

describe 'Requests' do
  context 'w/ trailing slash' do
    it 'sets X-Wiselinks header field correctly' do
      get('trailing-slash/', {}, {"X-Wiselinks" => 'template'})
      response.headers['X-Wiselinks-Url'].should =~ /trailing-slash\z/
    end
  end

  context 'w/out slash' do
    it 'sets X-Wiselinks header field correctly' do
      get('no-slash', {}, {"X-Wiselinks" => 'template'})
      response.headers['X-Wiselinks-Url'].last.should_not == '/'
    end
  end
end
