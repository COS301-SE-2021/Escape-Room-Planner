class FindAllPathsResponse
  attr_accessor :vertices , :error ,:pathcount, :endvert

  def initialize(vertices, error, pathcount,endvert)
    @vertices = vertices
    @pathcount=pathcount
    @error = error
    @endvert=endvert
  end


end


