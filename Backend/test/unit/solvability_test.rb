require 'test_helper'
require './app/Services/SolvabilitySubsystem/SolvabilityServices'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'

class SolvabilityTest < ActiveSupport::TestCase

  def test_solvability

    vertices = [1, 3, 4, 5, 6]

    solvabilityrq = CalculateSolvableRequest.new(1, 6, vertices)

    serv = SolvabilityService.new

    resp = serv.calculate_solvability(solvabilityrq)

    assert_equal(false, true)
  end

end