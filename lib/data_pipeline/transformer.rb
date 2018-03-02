require 'zlib'
require 'yajl'
require 'yaml'

module DataPipeline
  # This class will be used to transform data
  # from gz files to the data required for the results
  # of the CLI.
  class Transformer

    # @!group Attributes

    # @!attribute data
    # The dictionary of repository names to point values
    # created from parsed data.
    # @return [Hash]
    attr_reader :data

    # @!attribute filenames
    # An array of filenames to process
    # @return [Array]
    attr_reader :filenames

    # This method initializes an instance of Transform
    def initialize
      @data = {}
      @config = YAML.load(File.open(Dir.pwd + '/config.yml'))['EventTypes']
      @filenames = Dir.glob("./tmp/*.json.gz")
    end

    # @!group Instance Methods

    # This method recursively checks if the parsed
    # event JSON data matches the criteria from config.yml
    #
    # @return [Boolean]
    def matches_criteria?(event, criteria)
      criteria.each do |criterion, setting|
        if setting.is_a? Hash
          matches_criteria?(event[criterion], setting)
        else
          event[criterion] == setting
        end
      end
    end

    # This method parses uncompressed JSON data and
    # keeps track of repository point values
    def parse(js)
      Yajl::Parser.parse(js) do |event|
        name = event['repo']['name'] if event['repo']
        if name
          @data[name] ||= 0
          event_config = @config[event['type']]
          next unless event_config
          criteria = event_config['criteria']

          if criteria && matches_criteria?(event, criteria) || criteria.nil?
            @data[name] += event_config['points']
          end
        end
      end
    end

    # This method will iterate through all files
    # in tmp and parse them.
    #
    # An array of of the top repository data is returned.
    # @return [Array<Array>]
    def parse_files(top)
      @filenames.each do |filename|
        file = File.open(filename)

        begin
          parse(Zlib::GzipReader.new(file).read)

        rescue => e
          puts "Error parsing a file: " + filename + " message: " + e.message

        ensure
          file.close
        end

      end

      @data.sort_by { |_, v| v }.reverse.first(top)
    end
  end
end
