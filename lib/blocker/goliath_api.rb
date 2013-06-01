require 'goliath'
require 'em-http'
require 'em-synchrony/em-http'

module Blocker
  class GoliathApi < Goliath::API
    use Goliath::Rack::Params
  
    def self.subclass_for_pattern(p)
      subclass = Class.new(self) do
        use Goliath::Rack::Params
      end
      subclass.class_eval %Q'def pattern;#{p.inspect}; end'
      subclass
    end
  
    def pattern
      raise 'subclass and implement pattern, or use GoliathApi.subclass_for_pattern'
    end
  
    def on_headers(env, headers)
      env.logger.info 'proxying new request: ' + headers.inspect
      env['client-headers'] = headers
    end
  
    def call(env)
      if env['REQUEST_URI'] =~ self.pattern
        super(env)
      else
        [404, {}, "// BLOCKED\n"]
      end
    end

    def response(env)
      params = {:head => env['client-headers'], :query => env.params}

      req = EM::HttpRequest.new(env[Goliath::Request::REQUEST_URI])
      resp = case(env[Goliath::Request::REQUEST_METHOD])
        when 'GET'  then req.get(params)
        when 'POST' then req.post(params.merge(:body => env[Goliath::Request::RACK_INPUT].read))
        when 'HEAD' then req.head(params)
        else p "UNKNOWN METHOD #{env[Goliath::Request::REQUEST_METHOD]}"
      end

      response_headers = {}
      resp.response_header.each_pair do |k, v|
        response_headers[to_http_header(k)] = v
      end

      [resp.response_header.status, response_headers, resp.response]
    end

    # Need to convert from the CONTENT_TYPE we'll get back from the server
    # to the normal Content-Type header
    def to_http_header(k)
      k.downcase.split('_').collect { |e| e.capitalize }.join('-')
    end
  
  end
end