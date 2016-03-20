Feature: Simple placeholders in step Definitions

  Instead of using regexps for simple step definitions we can use :placeholders

  Scenario: Use place holders in step definitions
    Given a file named "features/step_definitions/steps.rb" with:
      """
      Given("there is a {shape}") do |shape|
        @shapes ||= []
        @shapes << shape
      end

      Then("there is/are :count shape(s)") do |count|
        expect(@shapes.count).to eq(count.to_i)
      end
      """
    And a file named "features/using_placeholders.feature" with:
      """
      Feature:
        Scenario:
          Given there is a square
          And there is a "scalar triangle"
          Then there are 2 shapes
      """
    When I run `cucumber --strict`
    Then it should pass

  Scenario: Reports the step matcher when it fails
    Given a file named "features/step_definitions/steps.rb" with:
      """
      Given("a step that {state}") do |state|
        fail if state =~ /fail/
      end
      """
    And a file named "features/using_placeholders.feature" with:
      """
      Feature: Failure mode
        Scenario: failing
          Given a step that fails
      """
    When I run `cucumber --strict`
    Then it should fail with:
      """
      Feature: Failure mode

        Scenario: failing         # features/using_placeholders.feature:2
          Given a step that fails # features/step_definitions/steps.rb:1
             (RuntimeError)
            ./features/step_definitions/steps.rb:2:in `"a step that :state"'
            features/using_placeholders.feature:3:in `Given a step that fails'

      Failing Scenarios:
      cucumber features/using_placeholders.feature:2 # Scenario: failing

      1 scenario (1 failed)
      1 step (1 failed)
      """
