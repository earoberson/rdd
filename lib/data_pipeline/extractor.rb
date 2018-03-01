require 'open-uri'
require 'date'

module DataPipeline
  # This class will be used to interface with the GitHub archive API
  # and download relevant gz data
  class Extractor
    BASE_URL = "http://data.githubarchive.org/"

    # @!group Attributes

    # @!attribute date
    # The date for which we are extracting data
    attr_reader :date

    # @!attribute filename
    # The filename for the extracted data
    attr_reader :filename

    def initialize(date)
      @date = date.strftime("%F") + '-' + date.strftime("%k").strip
      @filename = Dir.pwd + "/tmp/" + @date + ".json.gz"
    end

    def extract
      file = File.open(@filename, 'w')

      begin
        file << open(BASE_URL + @date + ".json.gz").read

      rescue => e
        puts e.message

      ensure
        file.close
      end
    end
  end
end
