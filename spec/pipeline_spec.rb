require 'minitest/autorun'
require './lib/pipeline'

describe DataPipeline::Pipeline do
  it "should process a data pipeline" do
    DataPipeline::Pipeline.respond_to?(:process).must_equal true
  end
end
