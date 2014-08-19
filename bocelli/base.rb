require_relative 'core/irc'

module Bocelli
  class Base
    def initialize(str, route, block, metadata)
      @bocelli = {
        str: str,
        route: route,
        block: block,
        metadata: metadata
      }
    end

    def execute
      instance_eval(&@bocelli[:block])
    end

    def out(message)
      self.class.privmsg(@bocelli[:metadata][:channel], message)
    end

    class << self
      include Bocelli::Core::IRC

      def setup
        @routes = {}
        @modules = {}
      end

      def inherited(subclass)
        super

        subclass.setup
      end

      def on(route, &block)
        @routes[route] = block
      end

      def register(mod)
        @modules[mod.name[/[^:]+$/].downcase.intern] ||= mod
      end

      def match?(str, route)
        case route
        when Regexp
          str =~ route
        when String
          str == route
        end
      end

      def match(str)
        @routes.detect { |k, _| match?(str, k) }
      end

      def mod_match(str)
        if str =~ /\A(\S+) (.*)/
          if (mod = Hash[@modules.map { |k, v| [k.to_s, v] }][$1])
            mod.match($2)
          end
        end
      end

      def process(str)
        if str =~ /\A:?(\S+) PRIVMSG (\S+) :?(.*)/
          metadata = {
            user: $1,
            channel: $2,
            message: $3
          }

          if (match = match($3)) || (match = mod_match($3))
            route, block = match

            new(str, route, block, metadata).execute
          end
        end
      end

      def run
        while (str = sgets)
          pong($1) if str =~ /\APING (.*)\z/

          process(str)
        end
      end
    end
  end
end
