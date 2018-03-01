require 'minitest/autorun'
require 'fileutils'
require './lib/pipeline'

describe DataPipeline::Extractor do
  describe "constants" do
    it "has a valid API URL" do
      DataPipeline::Extractor::BASE_URL.must_equal "http://data.githubarchive.org/"
    end
  end

  describe "instance methods" do
    date = DateTime.now
    git_date = date.strftime("%F") + '-' + date.strftime("%k").strip
    extractor = DataPipeline::Extractor.new(date)

    it "should have a date" do
      extractor.date.must_equal git_date
    end

    it "should have a filename" do
      extractor.filename.must_equal Dir.pwd + "/tmp/" + git_date + ".json.gz"
    end

    it "should be able to extract data" do
      extractor.respond_to?(:extract).must_equal true
    end

    it "should extract the file to the tmp dir" do
      extractor.extract
      Dir.glob("./tmp/#{git_date}.json.gz")[0].must_equal "./tmp/#{git_date}.json.gz"

      FileUtils.rm(Dir.glob("./tmp/*.json.gz"))
    end
  end
end
