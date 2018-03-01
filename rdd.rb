 #!/usr/bin/env ruby
require 'optparse'
require 'optparse/date'
require './lib/pipeline'

# TODO: add a data pipeline to extract, transform, and display results from
#       the githubarchive.org API
# TODO: add some spec to outline and detail the data pipeline

options = {}
OptionParser.new do |opts|
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

  opts.on("--after AFTER", DateTime,
          "Date to start search on, ISO8601 or YYYY-MM-DD format") do |v|
    options[:after] = v
  end

  opts.on("--before BEFORE", DateTime,
          "Date to end search on, ISO8601 or YYYY-MM-DD format") do |v|
    unless v > options[:after]
      raise ArgumentError, "BEFORE date must come after AFTER date"
    else
      options[:before] = v
    end
  end

  opts.on("--top N", Integer, "Number of repos to show") do |v|
    options[:top] = v
  end
end.parse!

DataPipeline::Pipeline.process
