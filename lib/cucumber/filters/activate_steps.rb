require 'cucumber/multiline_argument'
require 'cucumber/core/filter'

module Cucumber
  module Filters
    class ActivateSteps < Core::Filter.new(:step_definitions)

      def test_case(test_case, &descend)
        activator = ActivateTestCase.new(test_case, step_definitions)
        descend.call(activator)
        activator.test_case.describe_to(receiver)
      end

      class ActivateTestCase
        def initialize(test_case, step_definitions)
          @original_test_case = test_case
          @step_definitions = step_definitions
          @steps = []
        end

        def test_step(test_step)
          @steps << attempt_to_activate(test_step)
        end

        def test_case
          @original_test_case.with_steps(@steps)
        end

        private

        def attempt_to_activate(test_step)
          @step_definitions.find_match(test_step).activate(test_step)
        end
      end
    end
  end
end
