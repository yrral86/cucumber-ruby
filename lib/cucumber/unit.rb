module Cucumber
  class Unit
    def initialize(step_collection, feature_element)
      @step_collection = step_collection
      @feature_element = feature_element
    end

    def step_count
      @step_collection.length
    end

    def accept(visitor)
      visitor.visit_feature_element(@feature_element)
    end
  end
end
