require 'test_helper'
require './app/Services/SolvabilitySubsystem/solvability_service'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'

class SolvabilityTest < ActiveSupport::TestCase

  def test_solvability

    vertices = [1, 3, 4, 5, 6]

    solvabilityrq = CalculateSolvableRequest.new(1, 6, vertices)
    ss = SolvabilityService.new
    resp=ss.calculate_solvability(solvabilityrq)

    puts "hello"
    assert_equal(false, true)
  end

end