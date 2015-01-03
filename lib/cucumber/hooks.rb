module Cucumber

  # Hooks quack enough like Core::Ast source nodes that we can use them as source for steps
  module Hooks

    class << self
      def before_hook(source, &block)
        build_hook_step(source, block, BeforeHook, Core::Test::UnskippableAction)
      end

      private

      def build_hook_step(source, block, hook_type, action_type)
        action = action_type.new(&block)
        hook = hook_type.new(action.location)
        Core::Test::Step.new(source + [hook], action)
      end
    end

    class BeforeHook
      attr_reader :location

      def initialize(location)
        @location = location
      end

      def name
        "Before hook"
      end

      def match_locations?(queried_locations)
        queried_locations.any? { |other_location| other_location.match?(location) }
      end

      def describe_to(visitor, *args)
        visitor.before_hook(self, *args)
      end
    end

  end
end
