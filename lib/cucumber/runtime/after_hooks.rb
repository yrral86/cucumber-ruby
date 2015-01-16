module Cucumber
  class Runtime
    class AfterHooks
      def initialize(test_case, action_blocks)
        @test_case     = test_case
        @action_blocks = action_blocks
      end

      def apply(test_steps)
        test_steps + after_hooks
      end

      private
      def after_hooks
        @action_blocks.map do |action_block|
          Hooks.after_hook(@test_case.source, &action_block)
        end
      end

    end
  end
end

