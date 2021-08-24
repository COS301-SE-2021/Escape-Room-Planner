class FindAllPathsResponse
  attr_accessor :vertices , :error ,:pathcount

  def initialize(vertices, error, pathcount)
    @vertices = vertices
    @pathcount=pathcount
    @error = error
  end


end


