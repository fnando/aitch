RSpec.configure do |config|
  config.include Module.new {
    def add_hash_entry(source, target, from, to)
      target[to] = source[from] if source[from]
    end

    def register_uri(http_method, url, options = {})
      body = options.fetch(:body, '')
      status = options.fetch(:status, 200)
      headers = options.fetch(:headers, {})

      add_hash_entry(options, headers, :location, 'Location')
      add_hash_entry(options, headers, :content_type, 'Content-Type')
      add_hash_entry(options, headers, :content_encoding, 'Content-Encoding')

      stub_request(http_method, url)
        .to_return(status: status, body: body, headers: headers)
    end

    def last_request
      WebMock.requests.last
    end
  }
end
