require_relative 'data_pipeline/repository'
require_relative 'data_pipeline/extractor'
require 'tzinfo'

# The DataPipeline module will wrap the features of the Pipeline
module DataPipeline
  # The Pipeline class will serve as the main class for the Pipeline
  # and process options from the CLI
  class Pipeline
    TZ = TZInfo::Timezone.get('UTC')

    # @!attribute after_date
    # @!attribute after_date=
    # The start datetime for which to get data.
    attr_accessor :after_date

    # @!attribute before_dat
    # @!attribute before_date=
    # The end datetime for which to get data.
    attr_accessor :before_date

    # @!attribute num_results
    # @!attribute num_results=
    # The number of results we want to display.
    attr_accessor :num_results

    def initialize(options = {})
      @after_date = TZ.local_to_utc(options[:after] || DateTime.now - 28)
      @before_date = TZ.local_to_utc(options[:before] || DateTime.now)
      @num_results = options[:top] || 20
    end

    # This method will handle processing of the pipeline
    def process
    end
  end
end
