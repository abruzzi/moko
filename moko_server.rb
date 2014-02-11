require 'erb'
require 'json'
require 'active_support/inflector'
require 'fileutils'

module Moko
    class Dual
        def initialize name
            @name = name
            @fields = {}
        end

        def string field
            @fields[field.to_sym] = "defaultStringValue"
        end

        def float field
            @fields[field.to_sym] = 1.0
        end

        def integer field
            @fields[field.to_sym] = 1
        end

        def datetime field
            @fields[field.to_sym] = Time.now
        end

        def render
            JSON.pretty_generate(@fields)
        end
    end

    class Item
        attr_accessor :item
        def initialize(item)
            @item = item
        end
        def get_binding
            binding
        end
    end

    class Server
        attr_reader :items

        def self.draw &block
            server = Server.new
            server.instance_eval(&block)
            server.render
        end
        

        def touch_resources 
            @items.each do |item|
                FileUtils.touch "resources/#{item}.json"
            end
        end

        def render
            @items = @items.uniq
            touch_resources

            result = @items.reduce([]) do |result, item|
                result << ERB.new(@template).result(Item.new(item).get_binding)
            end
            resources = "[#{result.join(',')}]"

            File.open("conf/moko.conf.json", "w") { |f| f.write(resources) }
        end

        private
        def initialize
            @template = File.read("template/resource.erb")
            @items = []
            FileUtils.mkdir_p 'resources'
            FileUtils.mkdir_p 'conf'
        end

        def resources *arguments
            arguments.each do |item|
                @items << item
            end
        end

        def resource res, &block
            obj = Moko::Dual.new res
            obj.instance_eval(&block) if block_given?
            resources res.to_s.pluralize.to_sym
            File.open("resources/#{res.to_s.pluralize}.json", "w") { |io| io.write(obj.render) }
        end
    end
end
