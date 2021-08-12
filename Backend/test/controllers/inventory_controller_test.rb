# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class InventoryControllerTest < ActionDispatch::IntegrationTest
      test 'can add graphic to Inventory' do
        test_image = './storage/test/clue1.png'
        file = Rack::Test::UploadedFile.new(test_image, 'image/png')
        authed_post_call(api_v1_inventory_index_path, { image: file })
        response = JSON.parse(@response.body)
        assert_response :success
        assert_equal 'Graphic been added', response['message']
      end

      test 'correct response when no image added' do
        authed_post_call(api_v1_inventory_index_path, { image_fake: 'test' })
        response = JSON.parse(@response.body)
        assert_response :success
        assert_equal 'Error has occurred', response['message']
      end

      # TODO: inventory test with fake JWT

      test 'can get graphics for user' do
        authed_get_call(api_v1_inventory_index_path)
        response = JSON.parse(@response.body)
        assert_response :success
        assert_not_nil response['image']
      end

      # TODO: Assert get expected response for get graphics
    end
  end
end
