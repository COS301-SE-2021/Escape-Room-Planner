require 'test_helper'
require './app/Services/SolvabilitySubsystem/solvability_service'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'

class ErTest < ActiveSupport::TestCase
  
  def test_solvability
    
    
    assert_equal(true, true)
  end
  
end