# frozen_string_literal: true

require './app/Services/services_helper'

# rubocop:disable Metrics/ClassLength
module Api
  # v1 model definition for api calls
  module V1
    # Controller that maps http requests to functions to execute
    class RoomImageController < ApplicationController
      # GET api/v1/room_image/id
      def show
        # use id in params to select from room
        if authorise(request)
          room_id = params[:id]

          if room_id.nil?
            render json: { status: false, message: 'Invalid room id' }, status: :bad_request
          else
            room_images = RoomImage.select(
              :pos_x,
              :pos_y,
              :width,
              :height
            ).where(escape_room_id: room_id)
            # TODO: need to return blobs here, look at vertex service
            render json: { status: true, message: 'Returned the room images', data: room_images }, status: :ok
          end
        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      rescue StandardError => e
        render json: { status: false, error: e }, status: :bad_request
      end

      # POST api/v1/room_image
      def create
        # use id in params to attach to a room
        if authorise(request)
          pos_x = params[:pos_x]
          pos_y = params[:pos_y]
          width = params[:width]
          height = params[:height]
          escape_room_id = params[:escape_room_id]
          blob_id = params[:blob_id]

          if pos_x.nil? || pos_y.nil? || width.nil? || height.nil? || blob_id.nil? || escape_room_id.nil?
            render json: { status: false, message: 'Not all parameters were included' }, status: :bad_request
          else
            RoomImage.create(pos_x: pos_x, pos_y: pos_y, width: width, height: height, blob_id: blob_id,
                             escape_room_id: escape_room_id)
            render json: { status: true, message: 'Room image created' }, status: :ok
          end
        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      rescue StandardError => e
        render json: { status: false, error: e }, status: :bad_request
      end

      # PUT api/v1/room_image/image_id
      def update
        # use image_id to update the position and dimensions
        if authorise(request)
          # take all needed params and update the model in db
          image_id = params[:id]
          new_x = params[:pos_x]
          new_y = params[:pos_y]
          new_width = params[:width]
          new_height = params[:height]

          if image_id.nil? || new_x.nil? || new_y.nil? || new_width.nil? || new_height.nil?
            render json: { status: false, message: 'Not all parameters were included' }, status: :bad_request
          else
            room_image = RoomImage.find(image_id)
            room_image[:pos_x] = new_x
            room_image[:pos_y] = new_y
            room_image[:width] = new_width
            room_image[:height] = new_height

            render json: { status: true, message: 'Room image updated' }, status: :ok
          end
        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      rescue StandardError => e
        render json: { status: false, error: e }, status: :bad_request
      end
    end
  end
end
