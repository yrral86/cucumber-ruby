require 'cucumber/ast/step_collection'

module Cucumber
  module Ast
    class EmptyBackground
      attr_writer :file
      attr_accessor :feature

      def failed?
        false
      end

      def feature_elements
        []
      end

      def create_step_invocations(step_invocations)
        StepInvocations.new(step_invocations)
      end

      def step_invocations
        []
      end

      def init
      end

      def describe_to(visitor)
      end

      def accept(visitor)
      end

      def raw_steps
        []
      end
    end
  end
end

