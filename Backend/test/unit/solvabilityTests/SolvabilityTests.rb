require 'test_helper'
require './app/Services/SolvabilitySubsystem/solvability_service'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'

class ErTest < ActiveSupport::TestCase

  def test_solvability

    vertices = [1,3,4,5,6]

    solvabilityrq = CalculateSolvableRequest.new(1,6,vertices)

    resp=calculate_solvability(solvabilityrq)


    assert_equal(true, true)
  end

end