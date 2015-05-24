# Aitch

[![Build Status](https://travis-ci.org/fnando/aitch.png)](https://travis-ci.org/fnando/aitch)
[![Code Climate](https://codeclimate.com/github/fnando/aitch/badges/gpa.svg)](https://codeclimate.com/github/fnando/aitch)
[![Test Coverage](https://codeclimate.com/github/fnando/aitch/badges/coverage.svg)](https://codeclimate.com/github/fnando/aitch)
[![RubyGems](https://badge.fury.io/rb/aitch.png)](https://rubygems.org/gems/aitch)

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
response = Aitch.get("http://example.org", params, headers, options)
           Aitch.post("http://example.org", params, headers, options)
           Aitch.put("http://example.org", params, headers, options)
           Aitch.patch("http://example.org", params, headers, options)
           Aitch.delete("http://example.org", params, headers, options)
           Aitch.options("http://example.org", params, headers, options)
           Aitch.trace("http://example.org", params, headers, options)
           Aitch.head("http://example.org", params, headers, options)
```

You can also use a DSL.

```ruby
response = Aitch.get do
  url "http://simplesideias.com.br"
  headers Authorization: "Token token=abc"
  options follow_redirect: false
  params a: 1, b: 2
end
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
response.xml              # An alias to the Aitch::Response#data method
response.html             # An alias to the Aitch::Response#data method
response.json             # An alias to the Aitch::Response#data method
```

#### Parsing JSON, XML and HTML with Nokogiri

If your response is a JSON, XML or a HTML content type, we'll automatically convert the response into the appropriate object.

```ruby
response = Aitch.get("http://simplesideias.com.br")

response.html.class
#=> Nokogiri::HTML::Document

response.html.css("h1").size
#=> 69

response = Aitch.get("http://simplesideias.com.br/feed")

response.xml.class
#=> Nokogiri::XML::Document

response.xml.css("item").size
#=> 10

response = Aitch.get("https://api.github.com/users/fnando")
response.json.class
#=> Hash

response.json["login"]
#=> fnando
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

If the redirect limit is exceeded, then the `Aitch::TooManyRedirectsError` exception is raised.

### Basic auth

Setting basic auth credentials:

```ruby
response = Aitch.get do
  url "http://restrict.example.org/"
  options user: "john", password: "test"
end
```

### Setting custom headers

```ruby
Aitch.get do
  url "http://example.org"
  headers "User-Agent" => "MyBot/1.0.0"
end
```

The header value can be a callable object.

```ruby
Aitch.configure do |config|
  config.default_headers = {
    "Authorization" => -> { "Token token=#{ENV.fetch("API_TOKEN")}" }
  }
end
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

### Validating responses

When you know of kind of response you're expecting, you can validate the response with a list of accepted response statuses.

```ruby
Aitch.get do
  url "http://example.org"
  options expect: 200
end
```

If this request receives anything other than `200`, it will raise a `Aitch::StatusCodeError` exception.

```
Expect(200 OK) <=> Actual(404 Not Found)
```

You can also provide a list of accepted statuses, like `expect: [200, 201]`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
