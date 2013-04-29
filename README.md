# Aitch

[![Build Status](https://travis-ci.org/fnando/aitch.png)](https://travis-ci.org/fnando/aitch)

[![CodeClimate](https://codeclimate.com/github/fnando/aitch.png)](https://codeclimate.com/github/fnando/aitch/Aitch)

A simple HTTP client.

Features:

* Supports Gzip|Deflate response
* Automatically parses JSON and XML responses
* Automatically follows redirect

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aitch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aitch

## Usage

### Configuration

These are the default settings:

```ruby
Aitch.configure do |config|
  # Set request timeout.
  config.timeout = 5

  # Set default headers.
  config.default_headers = {}

  # Set follow redirect.
  config.follow_redirect = true

  # Set redirection limit.
  config.redirect_limit = 5

  # Set the user agent.
  config.user_agent = "Aitch/0.0.1 (http://rubygems.org/gems/aitch)"

  # Set the logger.
  config.logger = nil

  # Set the JSON parser.
  config.json_parser = JSON

  # Set the XML parser.
  config.xml_parser = Aitch::XMLParser
end
```

### Requests

Performing requests:

```ruby
response = Aitch.get("http://example.org", params, headers)
           Aitch.post("http://example.org", params, headers)
           Aitch.put("http://example.org", params, headers)
           Aitch.patch("http://example.org", params, headers)
           Aitch.delete("http://example.org", params, headers)
           Aitch.options("http://example.org", params, headers)
           Aitch.trace("http://example.org", params, headers)
           Aitch.head("http://example.org", params, headers)
```

### Response

The response object:

```ruby
response.html?
response.xml?
response.json?
response.content_type
response.headers
response.location
response.success?         # status >= 200 && status <= 399
response.redirect?        # status 3xx
response.error?           # status 4xx or 5xx
response.error            # response error
response.body             # returned body
response.data             # JSON or XML payload
```

### Following redirects

The configuration:

```ruby
Aitch.configure do |config|
  config.follow_redirect = true
  config.redirect_limit = 10
end
```

The request:

```ruby
Aitch.get("http://example.org")
```

If the redirect limit is exceeded, then the `Aitch::TooManyRedirectsError` exception
is raised.

### Basic auth

Setting basic auth credentials:

```ruby
Aitch.get("http://restrict.example.org/", {}, {}, user: "john", password: "test")
```

### Setting custom headers

```ruby
Aitch.get("http://example.org", {}, {"User-Agent" => "MyBot/1.0.0"})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
