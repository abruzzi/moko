require 'erb'
require 'json'
require 'yaml'
require 'active_support/inflector'
require 'fileutils'

module Moko
    class Dual
        def initialize
            @fields = {}
            @defaults = YAML.load_file("./defaults.yml")['defaults']
        end

        def method_missing(method, *args, &block)
            attr = method.to_s

            if @defaults.key?(attr)
                @fields[attr] = @defaults[attr]
            else
                super.method_missing(method, args, &block)
            end
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
        end

        def resources *arguments
            arguments.each do |item|
                @items << item
            end
        end

        def resource res, &block
            obj = Moko::Dual.new
            obj.instance_eval(&block) if block_given?
            resources res.to_s.pluralize.to_sym
            File.open("resources/#{res.to_s.pluralize}.json", "w") { |io| io.write(obj.render) }
        end
    end
end
