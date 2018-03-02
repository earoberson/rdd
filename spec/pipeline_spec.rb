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

        it "should have a list of dates to iterate over" do
          pipeline.dates.must_equal (date - 28).step(date, 1.0/24).map(&:to_datetime)
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

        it "should have a list of dates to iterate over" do
          pipeline.dates.must_equal options[:after].step(options[:before], 1.0/24).map(&:to_datetime)
        end
      end
    end

    describe "processing" do
      pipeline = DataPipeline::Pipeline.new(after: DateTime.now, top: 5)

      it "should display some data" do
        out = capture_io do
          pipeline.process
        end

        out.wont_be :empty?
      end

      it "should cleanup the tmp dir" do
        pipeline.process
        Dir.glob("./tmp/*.json.gz").must_equal []
      end

      it "gets an array of repository rank strings" do
        pipeline.stub :transform_data, [["one_repo", 2], ["another_repo", 5]] do
          pipeline.fetch_popular_repos.must_equal ["#1. one_repo - 2 points \n", "#2. another_repo - 5 points \n"]
        end
      end
    end
  end
end
