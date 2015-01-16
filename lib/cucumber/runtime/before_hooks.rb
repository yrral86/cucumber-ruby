module Cucumber
  class Runtime
    class BeforeHooks
      def initialize(test_case, action_blocks)
        @test_case     = test_case
        @action_blocks = action_blocks
      end

      def describe_to(visitor, *args)
        apply.describe_to(visitor, *args)
      end

      private
      def apply
        @test_case.with_steps(
          before_hooks + @test_case.test_steps
        )
      end

      def before_hooks
        @action_blocks.map do |action_block|
          Hooks.before_hook(@test_case.source, &action_block)
        end
      end

    end
  end
end
