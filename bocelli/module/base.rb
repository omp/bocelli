require_relative '../core/router'

module Bocelli
  module Module
    module Base
      include Bocelli::Core::Router

      def setup
        setup_router
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
