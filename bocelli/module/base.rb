module Bocelli
  module Module
    module Base
      attr_reader :routes

      def setup
        @routes = {}
      end

      def on(route, &block)
        raise 'no block given' if block.nil?

        @routes[route] = block
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

      class << self
        def extended(mod)
          super

          mod.setup
        end
      end
    end
  end
end
