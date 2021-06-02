class RoomServices

  def createPuzzle(request)

    if (request == nil)
      raise "CreatePuzzleRequest Null"
    end

    @puzzle = Puzzle.new
    @puzzle.save
    @response = CreatePuzzleResponse.new(@puzzle.id)

    # Return the response
    @response
  end

end