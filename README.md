# Aitch

[![Build Status](https://travis-ci.org/fnando/aitch.png)](https://travis-ci.org/fnando/aitch)
[![CodeClimate](https://codeclimate.com/github/fnando/aitch.png)](https://codeclimate.com/github/fnando/aitch/)
[![RubyGems](https://badge.fury.io/rb/aitch.png)](https://rubygems.org/gems/aitch)
[![Coveralls](https://coveralls.io/repos/fnando/aitch/badge.png?branch=master)](https://coveralls.io/r/fnando/aitch)

A simple HTTP client.

Features:

* Supports Gzip|Deflate response
* Automatically parses JSON, HTML and XML responses
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

  # Set the HTML parser.
  config.html_parser = Aitch::HTMLParser
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
response.data             # HTML, JSON or XML payload
```

#### Parsing XML and HTML with Nokogiri

If your response is a XML or a HTML content type, we'll automatically convert the response into a Nokogiri object.

```ruby
response = Aitch.get("http://simplesideias.com.br")

response.data.class
#=> Nokogiri::HTML::Document

response.data.css("h1").size
#=> 69
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

### Creating namespaced requests

Sometimes you don't want to use the global settings (maybe you're building a
lib). In this case, you can instantiate the namespace.

```ruby
Request = Aitch::Namespace.new
Request.configure do |config|
  config.user_agent = "MyLib/1.0.0"
end

Request.get("http://example.org")
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
