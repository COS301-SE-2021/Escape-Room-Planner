require 'test_helper'
require './app/Services/puzzle_services'
require './app/Services/create_puzzle_request'
require './app/Services/create_puzzle_response'



class PuzzleTest < ActiveSupport::TestCase

  def test_createPuzzle

    beforetest=Puzzle.count
    req = CreatePuzzleRequest.new("30", 30, "Recreate the image")
    rs = PuzzleServices.new
    rs.createPuzzle(req)

    assert_not_equal(Puzzle.count, beforetest)
  end

  def test_checkCreatePuzzleSaved
    req = CreatePuzzleRequest.new
    rs = PuzzleServices.new
    resp = rs.createPuzzle(req)

    assert_not_equal(resp.time, 0)
  end

  def test_checkCreatePuzzleNullRequest
    req = nil
    rs = PuzzleServices.new
    exception = assert_raise(StandardError){rs.createPuzzle(req)}
    assert_equal("CreatePuzzleRequest null", exception.message)
  end

end