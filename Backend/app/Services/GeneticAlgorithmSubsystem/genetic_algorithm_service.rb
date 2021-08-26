# frozen_string_literal: true
require './app/Services/GeneticAlgorithmSubsystem/Request/genetic_algorithm_request'
require './app/Services/GeneticAlgorithmSubsystem/Response/genetic_algorithm_response'

class GeneticAlgorithmService

  def genetic_algorithm(request)
    if request.vertices.nil? || request.linear.nil? || request.dead_nodes.nil?
        GeneticAlgorithmResponse.new("False","Parameters required")
    end



  end
  
  
  
end
