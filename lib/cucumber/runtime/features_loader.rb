require 'cucumber/errors'

module Cucumber
  class Runtime

    class FeaturesLoader
      include Formatter::Duration

      def initialize(feature_files, filters, tag_expression)
        @feature_files, @filters, @tag_expression = feature_files, filters, tag_expression
      end

      def features
        load unless (defined? @features) and @features
        @features
      end

    private

      def load
        features = Ast::Features.new

        start = Time.new
        log.debug("Features:\n")
        @feature_files.each do |f|
          feature_file = FeatureFile.new(f)
          feature = feature_file.parse(@filters)
          if feature
            features.add_feature(feature)
            log.debug("  * #{f}\n")
          end
        end
        duration = Time.now - start
        log.debug("Parsing feature files took #{format_duration(duration)}\n\n")

        @features = features
      end

      def log
        Cucumber.logger
      end
    end

  end
end
