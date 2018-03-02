require 'minitest/autorun'
require './lib/pipeline'
require 'json'

describe DataPipeline::Transformer do
  describe "instance methods" do
    it "should have a data hash" do
      DataPipeline::Transformer.new.data.must_equal Hash.new
    end

    it "should have a filenames array" do
      Dir.stub :glob, ["file1.json.gz", "file2.json.gz"] do
        transformer = DataPipeline::Transformer.new
        transformer.filenames.must_equal ["file1.json.gz", "file2.json.gz"]
      end
    end

    it "should be able to parse weird json text" do
      transformer = DataPipeline::Transformer.new
      json = { some: "weird", text: "in", json: "format" }.to_json
      transformer.parse(json)
      transformer.data.must_equal Hash.new
    end

    it "should be able to parse expected json text" do
      transformer = DataPipeline::Transformer.new
      json = { "repo" => { "name" => "foo/bar" }, "type" => "CreateEvent" }.to_json
      expected = { "foo/bar" => 10 }
      transformer.parse(json)
      transformer.data.must_equal expected
    end

    it "should be able to parse expected json text" do
      transformer = DataPipeline::Transformer.new
      json = {
               "type" => "PullRequestEvent",
               "repo" => {
                 "name" => "foo/baz"
               },
               "payload" => {
                 "action" => "closed",
                 "pull_request" => {
                   "merged" => "true"
                 }
               }
             }.to_json

      expected = { "foo/baz" => 2 }
      transformer.parse(json)
      transformer.data.must_equal expected
    end
  end
end
