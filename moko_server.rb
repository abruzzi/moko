require 'json'

module Moko
    class Server
        def self.draw(&block)
            server = Server.new
            server.instance_eval(&block)
            server
        end

        def initialize
        end

        def resource res
            obj = {}
            obj[:path] = res
            p obj.to_json  
        end
    end
end
