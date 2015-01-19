module Cucumber
  class Runtime
    class BeforeHooks
      def initialize(action_blocks)
        @action_blocks = action_blocks
      end

      def apply(test_case)
        test_case.with_steps(
           activate(test_case.source) + test_case.test_steps
        )
      end

      def activate(source)
        @action_blocks.map do |action_block|
          Hooks.before_hook(source, &action_block)
        end
      end
    end
  end
end
