require './app/Services/services_helper'
require './app/Services/GeneticAlgorithmSubsystem/genetic_algorithm_service'
require './app/Services/GeneticAlgorithmSubsystem/Request/genetic_algorithm_request'
require './app/Services/GeneticAlgorithmSubsystem/Response/genetic_algorithm_response'

# rubocop:disable Metrics/ClassLength
module Api
  # v1 model definition for api calls
  module V1
    # Controller that maps http requests to functions to execute
    class GeneticAlgorithmController < ApplicationController
      protect_from_forgery with: :null_session
      def create
        puts "here"
        room_id = params[:room_id]
        linear = params[:linear]
        dead_nodes = params[:dead_nodes]
        num_containers = params[:num_containers]
        num_puzzles = params[:num_puzzles]
        num_clues = params[:num_clues]
        num_keys = params[:num_keys]

        generateVertices(num_containers, num_puzzles, num_clues, num_keys, room_id)

        all = Vertex.all.where(escape_room_id: room_id)
        icount = 0
        vertices = []
        all.each do |v|
          vertices[icount] = v.id
          icount += 1
        end

         req = GeneticAlgorithmRequest.new(vertices, linear, dead_nodes, room_id)
         serv = GeneticAlgorithmService.new
         resp = serv.genetic_algorithm(req)


        render json: { status: 'Response received', message: 'Data:', data: resp }, status: :ok
      rescue StandardError
        render json: { status: 'FAILED', message: 'Unspecified error' }, status: :bad_request

      end


      def generateVertices(num_containers, num_puzzles, num_clues, num_keys , room_id)
        room = EscapeRoom.find_by_id(room_id)

        RoomImage.create(pos_x: 0, pos_y: 0, width: 900, height: 900, blob_id: -1,
                         escape_room_id: room_id)

        i_count = 0
        while i_count < num_clues.to_i

          @clue = Clue.new
          @clue.name = "GAClue"
          @clue.posx = rand(50..700)
          @clue.posy = rand(50..700)
          @clue.width = 60.0
          @clue.height = 60.0
          @clue.graphicid = "./assets/images/clue1.png"
          @clue.clue = "GAClue"
          @clue.escape_room_id = room_id
          @clue.blob_id = 0
          @clue.z_index = 6

          @clue.save
          i_count += 1
        end

        i_count = 0
        while i_count < num_puzzles.to_i
          puts "creating puzzle"
          @puzzle = Puzzle.new
          @puzzle.name = "GAPuzzle"
          @puzzle.posx = rand(50..700)
          @puzzle.posy = rand(50..700)
          @puzzle.width = 60.0
          @puzzle.height = 60.0
          @puzzle.graphicid = "./assets/images/puzzle1.png"
          @puzzle.estimatedTime = "13:03:37.726000"
          @puzzle.description = "GAPuzzle"
          @puzzle.escape_room_id = room_id
          @puzzle.blob_id = 0
          @puzzle.z_index = 6
          @puzzle.save
          i_count += 1
        end

        i_count = 0
        while i_count < num_keys.to_i
          @key = Keys.new
          @key.name = "GAKeys"
          @key.posx = rand(50..700)
          @key.posy = rand(50..700)
          @key.width = 60.0
          @key.height = 60.0
          @key.graphicid = "./assets/images/key1.png"
          @key.escape_room_id = room_id
          @key.blob_id = 0
          @key.z_index = 6
          @key.save
          i_count += 1
        end


        i_count = 0
        while i_count < num_containers.to_i
          @container = Container.new
          @container.posx = rand(50..700)
          @container.posy = rand(50..700)
          @container.width = 60.0
          @container.height = 60.0
          @container.name = "GAContainer"
          @container.graphicid = "./assets/images/con1.png"
          @container.escape_room_id = room_id
          @container.blob_id = 0
          @container.z_index = 6
          @container.save

          i_count += 1
        end


        room.save
      end
    end
  end
end

