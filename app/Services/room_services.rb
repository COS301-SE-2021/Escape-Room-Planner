class RoomServices

  def createPuzzle(request)

    if (request == nil)
      raise "CreatePuzzleRequest null"
    end

    @puzzle = Puzzle.new
    @puzzle.name = request.name
    @puzzle.escape_room_id = request.roomID
    @response = if @puzzle.save
      CreatePuzzleResponse.new(-1, false)
    else
      CreatePuzzleResponse.new(@puzzle.id, true)
                end
    # Return the response
    @response
  end

end