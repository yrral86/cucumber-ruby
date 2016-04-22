require 'cucumber/constantize'
require 'cucumber/runtime/for_programming_languages'
require 'cucumber/runtime/step_hooks'
require 'cucumber/runtime/before_hooks'
require 'cucumber/runtime/after_hooks'
require 'cucumber/events/step_match'
require 'cucumber/gherkin/steps_parser'

module Cucumber

  class Runtime

    class SupportCode

      include Constantize

      attr_reader :ruby
      def initialize(user_interface, configuration=Configuration.default)
        @configuration = configuration
        @runtime_facade = Runtime::ForProgrammingLanguages.new(self, user_interface)
        @ruby = Cucumber::RbSupport::RbLanguage.new(@runtime_facade, @configuration)
      end

      def configure(new_configuration)
        @configuration = Configuration.new(new_configuration)
      end

      def load_files!(files)
        log.debug("Code:\n")
        files.each do |file|
          load_file(file)
        end
        log.debug("\n")
      end

      def load_files_from_paths(paths)
        files = paths.map { |path| Dir["#{path}/**/*.rb"] }.flatten
        load_files! files
      end

      def unmatched_step_definitions
        @ruby.unmatched_step_definitions
      end

      def fire_hook(name, *args)
        @ruby.send(name, *args)
      end

      def step_definitions
        @ruby.step_definitions
      end

      def find_after_step_hooks(test_case)
        scenario = RunningTestCase.new(test_case)
        hooks = @ruby.hooks_for(:after_step, scenario)
        StepHooks.new hooks
      end

      def apply_before_hooks(test_case)
        scenario = RunningTestCase.new(test_case)
        hooks = @ruby.hooks_for(:before, scenario)
        BeforeHooks.new(hooks, scenario).apply_to(test_case)
      end

      def apply_after_hooks(test_case)
        scenario = RunningTestCase.new(test_case)
        hooks = @ruby.hooks_for(:after, scenario)
        AfterHooks.new(hooks, scenario).apply_to(test_case)
      end

      def find_around_hooks(test_case)
        scenario = RunningTestCase.new(test_case)

        @ruby.hooks_for(:around, scenario).map do |hook|
          Hooks.around_hook(test_case.source) do |run_scenario|
            hook.invoke('Around', scenario, &run_scenario)
          end
        end
      end

      private

      def load_file(file)
        log.debug("  * #{file}\n")
        @ruby.load_code_file(file)
      end

      def log
        Cucumber.logger
      end

    end
  end
end
