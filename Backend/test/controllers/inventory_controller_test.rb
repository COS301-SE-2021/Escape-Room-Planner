# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class InventoryControllerTest < ActionDispatch::IntegrationTest
      test 'can add graphic to Inventory' do
        test_image = './storage/test/clue1.png'
        base64_image =
          File.open(test_image, 'rb') do |file|
            Base64.strict_encode64(file.read)
          end
        authed_post_call(api_v1_inventory_index_path, { image: base64_image, type: 'clue' })
        response = JSON.parse(@response.body)
        assert_response :success
        assert_equal 'Graphic been added', response['message']
      end

      test 'correct response when no image added' do
        authed_post_call(api_v1_inventory_index_path, { image_fake: 'test',
                                                                 type: 'Clue'})
        response = JSON.parse(@response.body)
        assert_response :success
        assert_equal 'Please Send Image', response['message']
      end

      test 'JWT not added on add image request' do
        post api_v1_inventory_index_path, params: { image_fake: 'test',
                                                    type: 'Clue'}
        response = JSON.parse(@response.body)
        assert_response 401
        assert_equal 'Unauthorized', response['message']
      end

      test 'can get graphics for user' do
        authed_get_call(api_v1_inventory_index_path)
        response = JSON.parse(@response.body)
        assert_response :success
        assert_not_nil response['image']
      end

      test 'JWT not added on get graphics request' do
        get api_v1_inventory_index_path, params: { image_fake: 'test',
                                                    type: 'Clue'}
        response = JSON.parse(@response.body)
        assert_response 401
        assert_equal 'Unauthorized', response['message']
      end

      test 'can delete graphic through api call' do
        authed_delete_call("#{api_v1_inventory_index_path}/1", { blob_id: 1 })
        response = JSON.parse(@response.body)
        assert_response :success
        assert_equal 'Graphic been deleted', response['message']
      end

      test 'JWT not added on delete graphic request' do
        delete "#{api_v1_inventory_index_path}/1", params: { image_fake: 'test',
                                                   type: 'Clue'}
        response = JSON.parse(@response.body)
        assert_response 401
        assert_equal 'Unauthorized', response['message']
      end
    end
  end
end
