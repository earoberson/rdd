require 'minitest/autorun'
require './lib/pipeline'

describe DataPipeline::Repository do
  describe "instance methods" do
    data = { name: "some_name", points: 2, rank: 5 }
    repo = DataPipeline::Repository.new(data)

    it "should have a name" do
      repo.name.must_equal "some_name"
    end

    it "should have a point value" do
      repo.points.must_equal 2
    end

    it "should have a rank" do
      repo.rank.must_equal 5
    end

    it "should be able to display itself" do
      repo.respond_to?(:display).must_equal true
    end

    it "should display a string with its attributes" do
      repo.display.must_equal "#5. some_name - 2 points \n"
    end
  end
end
