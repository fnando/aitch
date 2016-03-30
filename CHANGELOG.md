# Changelog

* **unreleased**
    * Use frozen string magic comments
    * 307 redirections will honor the HTTP request method
* **0.5.0** - May 24, 2015
    * Remove hard dependency on ActiveSupport
    * Add response validation
* **0.4.1** - December 20, 2014
    * Consider default headers when returning content type (fixes issue with body's JSON encoding)
* **0.4.0** - December 18, 2014
    * Add accessor method for setting request's content type
    * Automatically encodes body as JSON when content type matches `json`
    * JSON encoding now uses a parser
* **0.3.0** - April 28, 2014
    * Make list of redirections available
    * Make the request URL available on responses
* **0.2.1** - July 30, 2013
    * Add alias for `response.success?` (`response.ok?`)
* **0.2.0** - July 28, 2013
    * Add DSL support
    * Create aliases for `response.data` (`response.xml` and `response.json`)
* **0.1.5** - June 26, 2013
    * Fix issue with jRuby and `to_h` protocol
* **0.1.4** - June 13, 2013
    * Accept headers as callable objects
    * Fix XML encoding, always converting values to UTF-8
* **0.1.3** - May 12, 2013
    * Add response HTML parsing into Nokogiri object
* **0.1.2** - May 10, 2013
    * Add response error code helpers, like `response.bad_request?` and `response.not_found?`
* **0.1.1** - April 30, 2013
    * Add support for namespaces
* **0.1.0** - April 29, 2013
    * Initial release
