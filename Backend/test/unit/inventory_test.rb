# frozen_string_literal: true

require 'test_helper'
require './app/Services/InventorySubsystem/inventory_service'
require './app/Services/InventorySubsystem/Request/add_graphic_request'
require './app/Services/InventorySubsystem/Response/add_graphic_response'

# Class that test inventory sub system
class InventoryTest < ActiveSupport::TestCase
  @@token = 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoyMzg2MDczMjMxfQ.Zwe1E5JKM40pXWoVgUaqcVsc5mPFt7HHj2k6f3WZZr0'

  test 'can add Graphic to Inventory' do
    test_image = 'C:/Users/donav/Desktop/Assignments/2021/COS301/Capstone/HTML/clue1.png'
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
end
