require 'cucumber/filters/activate_steps'
require 'cucumber/core/gherkin/writer'

describe Cucumber::Filters::ActivateSteps do
  include Cucumber::Core::Gherkin::Writer
  include Cucumber::Core

  let(:step_definitions) { double(matching_name: []) }
  let(:passing_step_definition) { double }
  let(:receiver) { double }

  context "for a step that has a matching step definition" do
    let(:doc) do
      gherkin do
        feature do
          scenario do
            step 'passing'
          end
        end
      end
    end

    before do
      allow(step_definitions).to receive(:matching_name).and_return(passing_step_definition)
    end

    it "activates the step" do
      expect(receiver).to receive(:test_case) do |test_case|
        step = test_case.test_steps.first
        expect(step.name).to eq 'passing'
        expect(step.execute).to be_passed
      end
      execute [doc]
    end
  end

  context "for a step with no matching step definition" do
    it "leaves the step undefined" do
    end
  end

  context "for a failing step definition" do
  end

  context "for a pending step definition" do
  end
end
