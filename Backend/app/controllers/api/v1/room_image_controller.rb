# frozen_string_literal: true

require './app/Services/services_helper'

# rubocop:disable Metrics/ClassLength
module Api
  # v1 model definition for api calls
  module V1
    # Controller that maps http requests to functions to execute
    class RoomImageController < ApplicationController
      protect_from_forgery with: :null_session
      @@room_service = RoomServices.new
      # GET api/v1/room_image/id
      def show
        # use id in params to select from room
        if authorise(request)
          room_id = params[:id]

          if room_id.nil?
            render json: { status: false, message: 'Invalid room id' }, status: :bad_request
          else
            room_images = RoomImage.select(
              :id,
              :pos_x,
              :pos_y,
              :width,
              :height,
              :blob_id
            ).where(escape_room_id: room_id)

            user = User.find_by_id(EscapeRoom.find_by_id(room_id).user_id)
            data = room_images.map do |k|
              blob_url = if (k.blob_id != 0) && !ActiveStorageBlobs.find_by_id(k.blob_id).nil?
                           Rails.application.routes.url_helpers.polymorphic_url(
                             user.graphic.blobs.find_by_id(k.blob_id), host: ENV.fetch('BLOB_HOST', 'localhost:3000')
                           )
                         else
                           './assets/images/room1.png'
                         end
              { room_image: k,
                src: blob_url }
            end

            render json: { status: true, message: 'Returned the room images', data: data }, status: :ok
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
            render json: { status: true, message: 'Room image created', data: RoomImage.select(:id).last }, status: :ok
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
            room_image.save

            render json: { status: true, message: 'Room image updated' }, status: :ok
          end
        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      rescue StandardError => e
        render json: { status: false, error: e }, status: :bad_request
      end

      # delete api/v1/room_image/image_id
      def destroy
        if authorise(request)
          room_image = RoomImage.find_by_id(params[:id])
          if room_image.nil?
            render json: { success: false, message: 'Room can not be found' }
          else
            room_image.destroy
            render json: { success: true, message: 'Room Deleted' }
          end
        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      rescue StandardError => e
        render json: { success: false, error: e }, status: :bad_request
      end
    end
  end
end
