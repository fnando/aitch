WebMock.disable_net_connect!(allow: /codeclimate\.com/)

def WebMock.requests
  @requests ||= []
end

WebMock.after_request do |request, response|
  WebMock.requests << request
end

RSpec.configure do |config|
  config.before(:each) do
    WebMock.requests.clear
  end
end
