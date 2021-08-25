require 'test_helper'
require './app/Services/SolvabilitySubsystem/SolvabilityServices'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_set_up_order_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_set_up_order_response'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/return_unnescessary_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/return_unnecessary_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/file_all_paths_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/find_all_paths_request'

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

  def test_circle_solvable
    vertices = [801, 802, 803, 804]

    solvability_req = CalculateSolvableRequest.new(801, 804, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_solvability(solvability_req)

    assert_equal(true, resp.solvable)
  end

  def test_set_up_legal_graph
    vertices = [1, 2, 3, 4, 5, 6]

    solvability_req = CalculateSetUpOrderRequest.new(1, 6, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_set_up_order(solvability_req)

    assert_equal('Success', resp.status)
  end

  def test_set_up_nil_req
    solvability_req = nil

    serv = SolvabilityService.new
    resp = serv.calculate_set_up_order(solvability_req)

    assert_equal('Solvability Request cant be null', resp.status)
  end

  def test_set_up_nil_param
    vertices = nil

    solvability_req = CalculateSetUpOrderRequest.new(1, 6, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_set_up_order(solvability_req)

    assert_equal('Parameters in request object cannot be null', resp.status)
  end

  def test_set_up_circle_graph
    vertices = [801, 802, 803, 804]

    solvability_req = CalculateSetUpOrderRequest.new(801, 804, vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_set_up_order(solvability_req)

    assert_equal('Success', resp.status)
  end

  def test_find_all_paths_legal_graph
    req = FindAllPathsRequest.new(901,912)
    serv = SolvabilityService.new
    resp = serv.find_all_paths_service(req)

    assert_equal("901,902,905,910,911,912",  resp.vertices[0])
    assert_equal("901,903,906,908,909,912",  resp.vertices[1])
  end

  def test_find_unnecessary_vertices
    req=ReturnUnnecessaryRequest.new(901,912, 3)
    serv = SolvabilityService.new
    resp=serv.find_unnecessary_vertices(req)

  end

end
