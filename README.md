# Aitch

[![Tests](https://github.com/fnando/aitch/actions/workflows/tests.yml/badge.svg)](https://github.com/fnando/aitch/actions/workflows/tests.yml)
[![Code Climate](https://codeclimate.com/github/fnando/aitch/badges/gpa.svg)](https://codeclimate.com/github/fnando/aitch)
[![Gem Version](https://img.shields.io/gem/v/aitch.svg)](https://rubygems.org/gems/aitch)
[![Gem Downloads](https://img.shields.io/gem/dt/aitch.svg)](https://rubygems.org/gems/aitch)

A simple HTTP client.

Features:

- Supports Gzip|Deflate response
- Automatically parses JSON, HTML and XML responses
- Automatically follows redirect

## Installation

Add this line to your application's Gemfile:

```ruby
gem "aitch"
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

  # Set the base url.
  config.base_url = nil
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

Finally, you can use keyword arguments:

```ruby
Aitch.get(
  url: "http://example.org",
  params: {a: 1, b: 2},
  headers: {Authorization: "Token token=abc"},
  options: {follow_redirect: false}
)
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
response.data             # Parsed response body
```

#### Parsing JSON, XML and HTML with Nokogiri

If your response is a JSON, XML or a HTML content type, we'll automatically
convert the response into the appropriate object.

```ruby
response = Aitch.get("http://simplesideias.com.br")

response.data.class
#=> Nokogiri::HTML::Document

response.data.css("h1").size
#=> 69

response = Aitch.get("http://simplesideias.com.br/feed")

response.data.class
#=> Nokogiri::XML::Document

response.data.css("item").size
#=> 10

response = Aitch.get("https://api.github.com/users/fnando")
response.data.class
#=> Hash

response.data["login"]
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

If the redirect limit is exceeded, then the `Aitch::TooManyRedirectsError`
exception is raised.

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

When you know the kind of response you're expecting, you can validate it by
specifying the `expect` option.

```ruby
Aitch.get do
  url "http://example.org"
  options expect: 200
end
```

If this request receives anything other than `200`, it will raise a
`Aitch::StatusCodeError` exception.

```
Expect(200 OK) <=> Actual(404 Not Found)
```

You can also provide a list of accepted statuses, like `expect: [200, 201]`.

### Response Parsers

You can register new response parsers by using
`Aitch::ResponseParser.register(name, parser)`, where parser must implement the
methods `match?(content_type)` and `load(response_body)`. This is how you could
load CSV values.

```ruby
require "csv"

module CSVParser
  def self.type
    :csv
  end

  def self.match?(content_type)
    content_type.to_s =~ /csv/
  end

  def self.load(source)
    CSV.parse(source.to_s)
  end
end

Aitch::ResponseParser.prepend(:csv, CSVParser)
```

The default behavior is returning the response body. You can replace it as the
following:

```ruby
module DefaultParser
  def self.type
    :default
  end

  def self.match?(content_type)
    true
  end

  def self.load(source)
    source.to_s
  end
end

# You should use append here, to ensure
# that is that last parser on the list.
Aitch::ResponseParser.append(:default, DefaultParser)
```

Aitch comes with response parsers for HTML, XML and JSON.

By default, the JSON parser will be `JSON`. To set it to something else, use
`Aitch::ResponseParser::JSONParser.engine`.

```ruby
require "oj"
Aitch::ResponseParser::JSONParser.engine = Oj
```

### Setting the base url

When you're creating a wrapper for an API, usually the hostname is the same for
the whole API. In this case, you can avoid having to pass it around all the time
by setting `Aitch::Configuration#base_url`. This option is meant to be used when
you instantiate a new namespace.

```ruby
Client = Aitch::Namespace.new

Client.configure do |config|
  config.base_url = "https://api.example.com"
end

Client.get("/users")
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
