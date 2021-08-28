# frozen_string_literal: true
require './app/Services/GeneticAlgorithmSubsystem/Request/genetic_algorithm_request'
require './app/Services/GeneticAlgorithmSubsystem/Response/genetic_algorithm_response'
require './app/Services/room_services'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'
require './app/Services/SolvabilitySubsystem/SolvabilityServices'

# Graph theory
# Max number edges undirected graph n(n-1)/2
# Max edges directed graph n(n-1)

class GeneticAlgorithmService

  def genetic_algorithm(request)
    puts ""
    puts "======================================================================================"
    puts "====================================GA Starts========================================="
    puts "======================================================================================"

    # Manipulate this if you want to mess with the initial edges for accuracy
    @max_edge_initial_factor = 0.25
    @min_edge_initial_factor = 0.5

    if request.vertices.nil? || request.linear.nil? || request.dead_nodes.nil?
      GeneticAlgorithmResponse.new('False', 'Parameters required')
    end


    # initial pop
    initial_population_creation(request.vertices)


    i_count = 0
    while i_count < @initial_population_size
      calculate_fitness(@initial_population[i_count], i_count ,request.room_id)
      i_count += 1
    end



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
    @initial_population_size = 1
    @fitness_of_population = []

    @chromosome_count = 0

    while @chromosome_count < @initial_population_size
      create_chromosome(rand(min_edges..max_edges), vertices)
    end
  end

  def create_chromosome(num_edges, vertices)

    i_count = 0
    @chromosome = Array.new(num_edges){Array.new(2){}}
    # Create that number of edges for the chromosome

    while i_count < num_edges
      @i_stop = 0
       return_vertices(vertices, i_count)
       @chromosome[i_count][0] = @vertex1
       @chromosome[i_count][1] = @vertex2
      i_count += 1
    end

    @initial_population.push(@chromosome)
    puts "             =========================================================================="
    puts "             ===================Chromosome number:#{(@chromosome_count + 1).to_s}===================================="
    puts "             =========================================================================="
    i_count = 0
    while i_count < num_edges
      puts "#{Vertex.find_by_id(@chromosome[i_count][0]).type}:#{@chromosome[i_count][0].to_s},#{Vertex.find_by_id(@chromosome[i_count][1]).type}:#{@chromosome[i_count][1].to_s}"
      i_count += 1
    end
    @initial_population[@chromosome_count] = @chromosome
    @chromosome_count += 1
  end

  def return_vertices(vert, i_count)
    @vertex1 = vert[rand(vert.count)]
    @vertex2 = vert[rand(vert.count)]
    # Checks on vertices come here
    return_vertices(vert, i_count) if @vertex1 == @vertex2
    t1 = Vertex.find_by_id(@vertex1).type
    t2 = Vertex.find_by_id(@vertex2).type

    # Check legal moves
    if (t1 == 'Clue' || t1 == 'Keys') && t2 != 'Puzzle'
      if @i_stop < 5
        @i_stop += 1
        return_vertices(vert, i_count)
      end
    end

    if t1 == 'Container' && t2 == 'Puzzle'
      if @i_stop < 5
        @i_stop += 1
        return_vertices(vert, i_count)
      end
    end

    if t1 == 'Puzzle' && t2 != 'Container'
      if @i_stop < 10
        @i_stop += 1
        return_vertices(vert, i_count)
      end
    end

    # Reduced duplicate connections && reversed connections
    if i_count > 0
      i_test = 0
      while i_test <= i_count
        if @chromosome[i_test][0] == @vertex1 && @chromosome[i_test][1] == @vertex2
          if @i_stop < 5
             @i_stop += 1
             return_vertices(vert, i_count)
          end
        end
        i_test += 1
      end

      i_test = 0
      while i_test <= i_count
        if @chromosome[i_test][1] == @vertex1 && @chromosome[i_test][0] == @vertex2
          if @i_stop < 5
            @i_stop += 1
            return_vertices(vert, i_count)
          end
        end
        i_test += 1
      end
    end
  end


  def calculate_fitness(chromosone,i_count,room_id)
    puts "======================================================================================"
    puts "==================================Fitness Scores======================================="
    puts "======================================================================================"


    # Fitness score out of 100
    set_up_room(chromosone,room_id)

    #init fitness
    i_init=0
    while i_init<@initial_population_size
      @fitness_of_population[i_init]=0
      i_init+=1
    end


    # most important solvable:
    all = Vertex.all.where(escape_room_id: room_id)
    i_vertex_add = 0
    vertices = []
    all.each do |v|
      vertices[i_vertex_add] = v.id
      i_vertex_add += 1
    end

    req = CalculateSolvableRequest.new(EscapeRoom.find_by_id(room_id).startVertex,EscapeRoom.find_by_id(room_id).endVertex,vertices)
    serv = SolvabilityService.new
    resp = serv.calculate_solvability(req)
    unless resp.solvable
      @fitness_of_population[i_count] = 0
    else
      @fitness_of_population[i_count]=@fitness_of_population[i_count]+20
      puts "Fitness of "+(i_count+1).to_s+" :" +@fitness_of_population[i_count].to_s
    end
  end

  def selection; end

  def crossover; end

  def mutation; end


  # helper functions
  def set_up_room(chromosone,room_id)
    start_node = find_start(chromosone)
    end_node = find_end(chromosone)
    room = EscapeRoom.find_by_id(room_id)

    # add start and end to room
     room.startVertex = start_node
     room.endVertex = end_node
  end

  def find_start(chromosone)
    start = chromosone[0][0]
    goodstart = false
    found = false
    chromosone.each do |row|

      if Vertex.find_by_id(row[0]).type == "Keys" && !goodstart
        start = row[0]
        chromosone.each do |row_inner|

          if row_inner[1] == start
            found = true
          end
        end

      unless found
        goodstart = true
      end
      end
    end

    puts "start_node: #{start.to_s}"
    start
  end

  def find_end(chromosone)
     end_node = chromosone[0][0]
     goodend = false
     found = false
     chromosone.each do |row|

       if Vertex.find_by_id(row[0]).type == "Container" && !goodend
         end_node = row[0]
         chromosone.each do |row_inner|

           if row_inner[1] == end_node
             found = true
           end
         end

         unless found
           goodend = true
         end
       end
     end

     puts "end_node: #{end_node}"
     end_node
  end

end
