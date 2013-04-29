module Aitch
  class Response
    class Body
      def initialize(response)
        @response = response
        @body = response.body
        @encoding = @response["content-encoding"]
      end

      def gzip?
        @encoding == "gzip"
      end

      def deflate?
        @encoding == "deflate"
      end

      def to_s
        if gzip?
          Zlib::GzipReader.new(StringIO.new(@body)).read
        elsif deflate?
          Zlib::Inflate.inflate(@body)
        else
          @body
        end
      end
    end
  end
end
