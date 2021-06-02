class PuzzleServices
  def createPuzzle(request)
    
    if (request == nil)
      raise "Create Request is Null"
    end

    @puzzle = Puzzle.new
    @puzle.save
    @response = CreatePuzzleResponse.new(@puzzle.time, @puzzle.pieces, @puzzle.description)

    # Return the response
    @response
  end

end