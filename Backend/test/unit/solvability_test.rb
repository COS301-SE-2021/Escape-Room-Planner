require 'test_helper'
require './app/Services/SolvabilitySubsystem/SolvabilityServices'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'

class SolvabilityTest < ActiveSupport::TestCase


  def test_solvability_legal_graph

    vertices = [1, 2, 3, 4, 5, 6]

    solvability_req = CalculateSolvableRequest.new(1, 6, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_solvability(solvability_req)

    assert_equal(true, resp.solvable)
  end

  def test_solvability_key_to_key

    vertices = [701, 700]

    solvability_req = CalculateSolvableRequest.new(701, 700, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_solvability(solvability_req)

    assert_equal(false, resp.solvable)
  end

  def test_solvability_key_to_puzzle
    vertices = [702, 703]

    solvability_req = CalculateSolvableRequest.new(702, 703, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_solvability(solvability_req)

    assert_equal(true, resp.solvable)
  end

  def test_solvability_container_to_puzzle
    vertices = [704, 705]

    solvability_req = CalculateSolvableRequest.new(704, 705, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_solvability(solvability_req)

    assert_equal(false, resp.solvable)
  end

  def test_solvability_container_to_container
    vertices = [706, 707]

    solvability_req = CalculateSolvableRequest.new(706, 707, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_solvability(solvability_req)

    assert_equal(true, resp.solvable)
  end

  def test_solvability_puzzle_to_not_container
    vertices = [708, 709]

    solvability_req = CalculateSolvableRequest.new(708, 709, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_solvability(solvability_req)

    assert_equal(false, resp.solvable)
  end

  def test_solvability_puzzle_to_container
    vertices = [710, 711]

    solvability_req = CalculateSolvableRequest.new(708, 709, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_solvability(solvability_req)

    assert_equal(true, resp.solvable)
  end

end
