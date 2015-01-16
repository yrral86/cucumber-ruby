require 'cucumber/core/filter'

module Cucumber
  module Filters
    class AddHooks < Core::Filter.new(:ruby)

      def test_case(test_case)
        CaseFilter.new(ruby, test_case).test_case.describe_to receiver
      end

      class CaseFilter
        def initialize(ruby, original_test_case)
          @ruby, @original_test_case = ruby, original_test_case
        end

        def test_case
          @original_test_case.
            with_steps(new_test_steps).
            with_around_hooks(around_hooks)
        end

        private

        def new_test_steps
          before_hooks + @original_test_case.test_steps + after_hooks
        end

        def around_hooks
          @ruby.hooks_for(:around, scenario).map do |hook|
            Hooks.around_hook(@original_test_case.source) do |run_scenario|
              hook.invoke('Around', scenario, &run_scenario)
            end
          end
        end

        def before_hooks
          []
        end

        def after_hooks
          []
        end

        def scenario
          @scenario ||= Mappings::Source.new(@original_test_case).build_scenario
        end
      end
    end
  end
end
