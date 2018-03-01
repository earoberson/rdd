module DataPipeline
  # This class will allow us to create repository objects and
  # display them to STDOUT
  class Repository

    # @!group Attributes

    # @!attribute name
    # @!attribute name=
    # The name of the repository
    attr_accessor :name

    # @!attribute points
    # @!attribute points=
    # The points associated with the repo
    attr_accessor :points

    # @!attribute rank
    # @!attribute rank=
    # The rank of the repository
    attr_accessor :rank

    # Initializes a repository object
    def initialize(options = {})
      @name = options[:name]
      @points = options[:points]
      @rank = options[:rank]
    end

    # Outputs the repository object to STDOUT
    def display
      "#%s. %s - %s points \n" % [@rank, @name, @points]
    end
  end
end
