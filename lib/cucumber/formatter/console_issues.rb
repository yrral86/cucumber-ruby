require 'cucumber/formatter/console'

module Cucumber
  module Formatter
    class ConsoleIssues
      include Console

      def initialize(config)
        @failures = []
        @config = config
        @config.on_event(:test_step_finished) do |event|
          @failures << event.test_step if event.result.failed?
        end
      end

      def to_s
        @failures.map { |f| format_failures(f) }
      end

      def any?
        @failures.any?
      end

      private

      def format_failures(_f)
        %(
Scenario: <scenario name> - <scenario path>
Step: <Step name> - <step path>
Step Definition: <step definition>
Message: <stack>
         )
      end
    end
  end
end
