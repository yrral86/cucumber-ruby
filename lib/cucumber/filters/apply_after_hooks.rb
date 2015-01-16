module Cucumber
  module Filters
    class ApplyAfterHooks < Core::Filter.new(:hooks)
      def test_case(test_case)
        test_steps = hooks.find_after_hooks(test_case).apply(test_case.test_steps)
        test_case.with_steps(test_steps).describe_to(receiver)
      end
    end
  end
end
