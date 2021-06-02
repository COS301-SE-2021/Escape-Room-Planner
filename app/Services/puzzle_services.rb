class PuzzleServices

  def createPuzzle(request)

    if  request == nil
      raise "CreatePuzzleRequest null"
    end

    @puzzle = EscapeRoom.new
    @puzzle.save
    @response = CreatePuzzleResponse.new(@puzzle.time, @puzzle.pieces, @puzzle.description)
    @response

  end

end