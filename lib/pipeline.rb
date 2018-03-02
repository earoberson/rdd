require_relative 'data_pipeline/repository'
require_relative 'data_pipeline/extractor'
require_relative 'data_pipeline/transformer'
require 'tzinfo'
require 'fileutils'

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

    # This method intilizes a Pipeline and sets
    # pipeline config
    def initialize(options = {})
      @after_date = TZ.local_to_utc(options[:after] || DateTime.now - 28)
      @before_date = TZ.local_to_utc(options[:before] || DateTime.now)
      @num_results = options[:top] || 20
    end

    # This method will handle processing of the pipeline
    def process
      puts "Getting Github statistics for #{dates.first} - #{dates.last}"

      extract_data
      display_data
      cleanup_data
    end

    def dates
      @after_date.step(@before_date, 1.0/24).map(&:to_datetime)
    end

    # This method extracts data for each hour between
    # the config dates
    def extract_data
      dates.each do |date|
        Extractor.new(date).extract
      end
    end

    # This method transforms the data into a parsable
    # format to create results and display them.
    def transform_data
      Transformer.new.parse_files(@num_results)
    end

    # This method iterates over transformed data
    # and creates repositories with points and ranks
    # and gets the display string.
    def fetch_popular_repos
      transform_data.each_with_index.map do |datum, i|
        Repository.new(
                        name: datum.first,
                        points: datum.last,
                        rank: i + 1
                      ).display
      end
    end

    # This method outputs each repository's display string
    # to STDOUT.
    def display_data
      fetch_popular_repos.each { |repo| puts repo }
    end

    # This method cleans up all files in the tmp directory.
    def cleanup_data
      FileUtils.rm(Dir.glob("./tmp/*.json.gz"))
    end
  end
end
