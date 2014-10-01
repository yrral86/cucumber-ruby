Feature: State

  You can pass state between step by setting instance variables,
  but those instance variables will be gone when the next scenario runs.

  Scenario: Set an ivar in one scenario, use it in the next step
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given I have set @flag = true
          Then @flag should be true

        Scenario:
          Then @flag should be nil
      """
    And a file named "features/step_definitions/steps.rb" with:
      """
      Given /set @flag/ do
        @flag = true
      end
      Then /flag should be true/ do
        raise "expected @flag to be truthy, but it was falsey" unless @flag
      end
      Then /flag should be nil/ do
        raise "expected @flag to be nil, but it was #{@flag}" unless @flag.nil?
      end
      """
    When I run `cucumber`
    Then it should pass


