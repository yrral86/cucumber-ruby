require 'spec_helper'
require 'cucumber/formatter/spec_helper'
require 'cucumber/formatter/pretty'

module Cucumber
  module RbSupport
    describe RbWorld do
      extend Cucumber::Formatter::SpecHelperDsl
      include Cucumber::Formatter::SpecHelper

      describe 'Handling puts in step definitions' do
        before(:each) do
          Cucumber::Term::ANSIColor.coloring = false
          @out = StringIO.new
          @formatter = Cucumber::Formatter::Pretty.new(runtime, @out, {})
          run_defined_feature
        end

        describe 'when modifying the printed variable after the call to puts' do
          define_feature <<-FEATURE
        Feature: Banana party

          Scenario: Monkey eats banana
            When puts is called twice for the same variable
          FEATURE

          define_steps do
            When(/^puts is called twice for the same variable$/) do
              foo = 'a'
              puts foo
              foo.upcase!
              puts foo
            end
          end

          it 'prints the variable value at the time puts was called' do
            expect( @out.string ).to include <<OUTPUT
    When puts is called twice for the same variable
      a
      A
OUTPUT
          end
        end
      end

      let(:scenario_context) { Object.new.extend(RbSupport::RbWorld) }

      describe "#doc_string" do
        it 'defaults to a blank content-type' do
          actual = scenario_context.doc_string('DOC')
          expect(actual).to be_kind_of(MultilineArgument::DocString)
          expect(actual.content_type).to eq('')
        end

        it 'can have a content type' do
          actual = scenario_context.doc_string('DOC','ruby')
          expect(actual.content_type).to eq('ruby')
        end
      end

      describe "#table" do
        it 'produces Ast::Table by #table' do
          input = %{
        | account | description | amount |
        | INT-100 | Taxi        | 114    |
        | CUC-101 | Peeler      | 22     |
          }
          expect(scenario_context.table(input)).to be_kind_of \
            MultilineArgument::DataTable
        end
      end

    end
  end
end
