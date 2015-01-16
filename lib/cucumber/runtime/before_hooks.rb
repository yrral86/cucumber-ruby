module Cucumber
  class Runtime
    class BeforeHooks
      def initialize(test_case, action_blocks)
        @test_case     = test_case
        @action_blocks = action_blocks
      end

      def apply(test_steps)
        before_hooks + test_steps
      end

      private
      def before_hooks
        @action_blocks.map do |action_block|
          Hooks.before_hook(@test_case.source, &action_block)
        end
      end

    end
  end
end
