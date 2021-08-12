# frozen_string_literal: true

require 'test_helper'
require './app/Services/InventorySubsystem/inventory_service'
require './app/Services/InventorySubsystem/Request/add_graphic_request'
require './app/Services/InventorySubsystem/Response/add_graphic_response'
require './app/Services/InventorySubsystem/Request/get_graphics_request'
require './app/Services/InventorySubsystem/Response/get_graphics_response'

# Class that test inventory sub system
class InventoryTest < ActiveSupport::TestCase
  @@token = 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoyMzg2MDczMjMxfQ.Zwe1E5JKM40pXWoVgUaqcVsc5mPFt7HHj2k6f3WZZr0'
  @@fake_token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'
  test 'can add Graphic to Inventory' do
    test_image = './storage/test/clue1.png'
    file = Rack::Test::UploadedFile.new(test_image, 'image/png')
    request = AddGraphicRequest.new(@@token, file)
    serv = InventoryService.new
    response = serv.add_graphic(request)
    assert_equal(response.message, 'Graphic been added')
  end

  test 'can handle incorrect image upload' do
    request = AddGraphicRequest.new(@@token, 'incorrect type')
    serv = InventoryService.new
    response = serv.add_graphic(request)
    assert_equal(response.message, 'Error has occurred')
  end

  # TODO: do test on incorrect JWT token given

  test 'gets all user graphics' do
    request = GetGraphicsRequest.new(@@token)
    serv = InventoryService.new
    response = serv.get_graphics(request)
    assert_equal(response.message, 'User Inventory Graphics Obtained')
    assert_not_nil(response.image)
  end

  test 'fake token passed' do
    request = GetGraphicsRequest.new(@@fake_token)
    serv = InventoryService.new
    response = serv.get_graphics(request)
    assert_equal(response.message, 'Error has occurred')
  end
end
