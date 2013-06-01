require_relative './goliath_api'

module Blocker
  class Proxy
    def initialize(pattern)
      api_class = GoliathApi.subclass_for_pattern pattern
      api = api_class.new
      @runner = Goliath::Runner.new(['--port', self.port.to_s], api)
      @runner.app = Goliath::Rack::Builder.build(api_class, api)
    
      Goliath::Application.app_class = BeQuietGoliath
    end
  
    def start
      @thread = Thread.new {
        @runner.run
      }
    end
  
    def stop
      @thread.exit
    end
  
    def host
      '127.0.0.1'
    end
  
    def port
      9876
    end
  
    def host_and_port
      "#{host}:#{port}"
    end
  
    private
  
    # i should fix this in goliath, some slightly weird coupling
    # between the runner/builder and application means
    # it grumbles on exit without this
    class BeQuietGoliath < Goliath::API
      def response(env)
        [200, {}, "otherwise goliath grumbles"]
      end
    end
  end
end