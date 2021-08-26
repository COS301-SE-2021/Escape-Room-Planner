# frozen_string_literal: true
require './app/Services/GeneticAlgorithmSubsystem/Request/genetic_algorithm_request'
require './app/Services/GeneticAlgorithmSubsystem/Response/genetic_algorithm_response'

# Graph theory
# Max number edges undirected graph n(n-1)/2
# Max edges directed graph n(n-1)


class GeneticAlgorithmService

  def genetic_algorithm(request)
    puts ""
    puts "======================================================================================"
    puts "====================================GA Starts========================================="
    puts "======================================================================================"

    #Manipulate this if you want to mess with the initial edges for accuracy
    @max_edge_initial_factor=1
    @min_edge_initial_factor=1

    if request.vertices.nil? || request.linear.nil? || request.dead_nodes.nil?
      GeneticAlgorithmResponse.new('False', 'Parameters required')
    end

    #@initial_population = [][]
    initial_population_creation(request.vertices)

  end
  
  def initial_population_creation(vertices)
    # Max edges = n(n-1)
    max_edges = (vertices.count)*(vertices.count - 1)*@max_edge_initial_factor
    puts "Max edges: #{max_edges}"

    # Min edges = n-1
    min_edges = vertices.count - 1*@min_edge_initial_factor
    puts "Min edges: #{min_edges}"

  end

  def calculate_fitness; end

  def selection; end

  def crossover; end

  def mutation; end
  
end
