require './app/Services/GeneticAlgorithmSubsystem/Request/genetic_algorithm_request'
require './app/Services/GeneticAlgorithmSubsystem/Response/genetic_algorithm_response'
require './app/Services/GeneticAlgorithmSubsystem/genetic_algorithm_service'

class GeneticAlgorithmTest < ActiveSupport::TestCase

  test 'basic GA test' do
     vertices = [201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217]

     req = GeneticAlgorithmRequest.new(vertices, "med", "med", 5)
     serv = GeneticAlgorithmService.new
     resp = serv.genetic_algorithm(req)

  end

end
