# frozen_string_literal: true
require './app/Services/GeneticAlgorithmSubsystem/Request/genetic_algorithm_request'
require './app/Services/GeneticAlgorithmSubsystem/Response/genetic_algorithm_response'

# Graph theory
# Max number edges undirected graph n(n-1)/2
# Max edges directed graph n(n-1)

class GeneticAlgorithmService
  @clue_const = 'Clue'
  @key_const = 'Keys'
  @container_const = 'Container'
  @puzzle_const = 'Puzzle'
  def genetic_algorithm(request)
    puts ""
    puts "======================================================================================"
    puts "====================================GA Starts========================================="
    puts "======================================================================================"

    # Manipulate this if you want to mess with the initial edges for accuracy
    @max_edge_initial_factor = 0.5
    @min_edge_initial_factor = 0.5

    if request.vertices.nil? || request.linear.nil? || request.dead_nodes.nil?
      GeneticAlgorithmResponse.new('False', 'Parameters required')
    end


    initial_population_creation(request.vertices)



  end
  
  def initial_population_creation(vertices)
    puts "======================================================================================"
    puts "==================================Initial Pop========================================="
    puts "======================================================================================"

    # Max edges = n(n-1)
    max_edges = ((vertices.count) * (vertices.count - 1) * @max_edge_initial_factor).round
    puts "Max edges: #{max_edges}"

    # Min edges = n-1
    min_edges = ((vertices.count - 1) * @min_edge_initial_factor).round
    puts "Min edges: #{min_edges}"
    
    # Single Chromosome
    # Array of 2D arrays for initial population
    @initial_population = []
    @initial_population_size = 10
    @chromosome_count = 0

    while @chromosome_count < @initial_population_size
      create_chromosone(rand(min_edges..max_edges), vertices)
    end
  end

  def create_chromosone(num_edges, vertices)

    i_count = 0
    @chromosome = Array.new(num_edges){Array.new(2){}}
    # Create that number of edges for the chromosome

    while i_count < num_edges
      @i_stop = 0
       return_vertices(vertices)
       @chromosome[i_count][0] = @vertex1
       @chromosome[i_count][1] = @vertex2
       i_count += 1
    end

    @initial_population.push(@chromosome)
    puts "             =========================================================================="
    puts "             ===================Chromosome number:" + (@chromosome_count + 1).to_s + "===================================="
    puts "             =========================================================================="
    i_count = 0
    while i_count < num_edges - 1
      puts Vertex.find_by_id(@chromosome[i_count][0]).type+":"+@chromosome[i_count][0].to_s + "," + Vertex.find_by_id(@chromosome[i_count][1]).type+":"+@chromosome[i_count][1].to_s
      i_count += 1
    end
    @initial_population[@chromosome_count] = @chromosome
    @chromosome_count += 1
  end

  def return_vertices(vert)
    @vertex1 = vert[rand(vert.count)]
    @vertex2 = vert[rand(vert.count)]

    # Checks on vertices come here
    return_vertices(vert) if @vertex1 == @vertex2

    # This stops infinite recursion

    # Check legal moves
    if (Vertex.find_by_id(@vertex1).type == @clue_const || Vertex.find_by_id(@vertex1).type == @key_const) && !Vertex.find_by_id(@vertex2).type == @puzzle_const
      if @i_stop < 4
        @i_stop += 1
        return_vertices(vert)
      else
        @vertex1 = nil
        @vertex2 = nil
      end
    end

    if Vertex.find_by_id(@vertex1).type == @container_const && Vertex.find_by_id(@vertex2).type == @puzzle_const
      if @i_stop < 4
        @i_stop += 1
        return_vertices(vert)
      else
        @vertex1 = nil
        @vertex2 = nil
      end
    end

    if Vertex.find_by_id(@vertex1).type == @puzzle_const && !Vertex.find_by_id(@vertex2).type == @container_const
      if @i_stop < 4
        @i_stop += 1
        return_vertices(vert)
      else
        @vertex1 = nil
        @vertex2 = nil
      end
    end



  end

  
  def calculate_fitness; end

  def selection; end

  def crossover; end

  def mutation; end


end
