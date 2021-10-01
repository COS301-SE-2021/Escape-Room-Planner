require './app/Services/room_services'
require './app/Services/services_helper'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'
require './app/Services/RoomSubsystem/Request/get_rooms_request'
require './app/Services/RoomSubsystem/Response/get_rooms_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_estimated_time_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_estimated_time_response'
require './app/Services/SolvabilitySubsystem/SolvabilityServices'

module Api
  module V1
    class RoomSharingController < ApplicationController
      # Get vertices
      def index
        # Room rating username time

        rooms = PublicRoom.all
        return_array = Array.new(rooms.size) { Array.new(4) }
        i_count = 0

        rooms.each do |room|
          return_array[i_count][0] = room
          return_array[i_count][1] = 3.5

          escape_room = EscapeRoom.find_by(room.RoomID)


          return_array[i_count][2] = escape_room.user_id

          s_s = SolvabilityService.new
          req = CalculateEstimatedTimeRequest.new(escape_room.startVertex, escape_room.endVertex)
          resp = s_s.calculate_estimated_time(req)
          return_array[i_count][3] = resp.time

          i_count += 1
        end


        render json: { status: 'success', data: return_array }, status: :ok
      rescue StandardError
        render json: { status: 'Fail', message: 'Unknown Error' }, status: :not_found
      end

      def update
        if params[:operation].nil?
          render json: { status: 'Failed', message: 'Specify operation' }, status: :bad_request
          return
        end


        if params[:operation] == 'AddPublic'
          if params[:RoomID].nil?
            render json: { status: 'Failed', message: 'RoomID cannot be null' }, status: :bad_request
            return
          end

          room = PublicRoom.new(RoomID: params[:RoomID])
          if room.save
            render json: { status: 'Success', message: 'Room added to public' }, status: :ok
          else
            render json: { status: 'Failed', message: 'could not add room' }, status: :bad_request
          end
        end

        if params[:operation] == 'RemovePublic'
          room = PublicRoom.find_by(RoomID: params[:RoomID])
          if room.destroy
            render json: { status: 'Success', message: 'RoomDestroyed' }, status: :ok
          else
            render json: { status: 'Failed', message: 'could not destroy room' }, status: :bad_request
          end
        end

        if params[:operation] == 'AddRating'
          rating = RoomRating.new(RoomID: params[:RoomID], Rating: params[:Rating])
          if rating.save
            render json: { status: 'Success', message: 'RoomAdded' }, status: :ok
          else
            render json: { status: 'Failed', message: 'could not save room' }, status: :bad_request
          end


        end



      rescue StandardError
        render json: { status: 'Fail', message: 'Unknown Error' }, status: :not_found
      end

    end
  end
end

