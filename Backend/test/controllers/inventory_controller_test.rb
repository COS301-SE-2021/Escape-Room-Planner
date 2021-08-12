# frozen_string_literal: true

require 'test_helper'

class Api::V1::InventoryControllerTest < ActionDispatch::IntegrationTest
  test 'can add graphic to Inventory' do
    test_image = './storage/test/clue1.png'
    file = Rack::Test::UploadedFile.new(test_image, 'image/png')
    authed_post_call(api_v1_inventory_index_path, { image: file })
    response = JSON.parse(@response.body)
    assert_response :success
    assert_equal 'Graphic been added', response['message']
  end

  test 'correct response when no image added' do
    authed_post_call(api_v1_inventory_index_path, { imaget: 'test' })
    response = JSON.parse(@response.body)
    assert_response :success
    assert_equal 'Error has occurred', response['message']
  end

end
