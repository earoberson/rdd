require 'minitest/autorun'
require './lib/pipeline'

describe DataPipeline::Pipeline do
  describe "constants" do
    it "timezone should be UTC" do
      DataPipeline::Pipeline::TZ.must_equal TZInfo::Timezone.get('UTC')
    end
  end

  describe "instance methods" do
    tz = DataPipeline::Pipeline::TZ

    describe "without options" do
      DateTime.stub :now, DateTime.now do
        date = DateTime.now
        pipeline = DataPipeline::Pipeline.new

        it "should process a data pipeline" do
          pipeline.respond_to?(:process).must_equal true
        end

        it "should have an after date defaulted to 28 days ago" do
          pipeline.after_date.must_equal tz.local_to_utc(date - 28)
        end

        it "should have a before date defaulted to now" do
          pipeline.before_date.must_equal tz.local_to_utc(date)
        end

        it "should default to display 20 results" do
          pipeline.num_results.must_equal 20
        end
      end
    end

    describe "with options" do
      DateTime.stub :now, DateTime.now do
        options = { after: DateTime.now - 4, before: DateTime.now - 2, top: 100 }
        pipeline = DataPipeline::Pipeline.new(options)

        it "should process a data pipeline" do
          pipeline.respond_to?(:process).must_equal true
        end

        it "should have an after date of 4 days ago" do
          pipeline.after_date.must_equal tz.local_to_utc(options[:after])
        end

        it "should have a before date of 2 days ago" do
          pipeline.before_date.must_equal tz.local_to_utc(options[:before])
        end

        it "should display 100 results" do
          pipeline.num_results.must_equal 100
        end
      end
    end
  end
end
