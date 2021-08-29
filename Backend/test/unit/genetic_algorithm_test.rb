require './app/Services/GeneticAlgorithmSubsystem/Request/genetic_algorithm_request'
require './app/Services/GeneticAlgorithmSubsystem/Response/genetic_algorithm_response'
require './app/Services/GeneticAlgorithmSubsystem/genetic_algorithm_service'

class GeneticAlgorithmTest < ActiveSupport::TestCase

  test 'basic GA test' do
    vertices = [201, 202, 203, 204, 205, 206]

    req = GeneticAlgorithmRequest.new(vertices, "low", "low", 5)
    serv = GeneticAlgorithmService.new
    resp = serv.genetic_algorithm(req)

  end

end
