# frozen_string_literal: true

require 'test_helper'
require 'base64'
require './app/Services/InventorySubsystem/inventory_service'
require './app/Services/InventorySubsystem/Request/add_graphic_request'
require './app/Services/InventorySubsystem/Response/add_graphic_response'
require './app/Services/InventorySubsystem/Request/get_graphics_request'
require './app/Services/InventorySubsystem/Response/get_graphics_response'
require './app/Services/InventorySubsystem/Request/delete_graphic_request'
require './app/Services/InventorySubsystem/Response/delete_graphic_response'

# Class that test inventory sub system
class InventoryTest < ActiveSupport::TestCase
  @@fake_token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'
  test 'can add Graphic to Inventory' do
    test_image = './storage/test/clue1.png'
    base64_image =
      File.open(test_image, 'rb') do |file|
        Base64.strict_encode64(file.read)
      end
    base64_image = "data:image/png;#{base64_image}"
    request = AddGraphicRequest.new(login_for_test, base64_image, 'Clue')
    serv = InventoryService.new
    response = serv.add_graphic(request)
    assert_equal(response.message, 'Graphic been added')
  end

  test 'can handle incorrect image upload' do
    request = AddGraphicRequest.new(login_for_test, nil, 'Clue')
    serv = InventoryService.new
    response = serv.add_graphic(request)
    assert_equal(response.message, 'Please Send Image')
  end

  test 'can handle fake JWT request image upload' do
    request = AddGraphicRequest.new(@@fake_token, "lop", 'Clue')
    serv = InventoryService.new
    response = serv.add_graphic(request)
    assert_equal(response.message, 'Error has occurred, can not add graphic')
  end

  test 'gets all user graphics' do
    request = GetGraphicsRequest.new(login_for_test)
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

  test 'can delete graphic for user' do
    request = DeleteGraphicRequest.new(login_for_test, 1)
    serv = InventoryService.new
    response = serv.delete_graphic(request)
    assert_not(ActiveStorageAttachments.where(blob_id: 1).nil?)
    assert_equal(response.message, 'Graphic been deleted')
  end

  test 'can handle no existent blob id' do
    request = DeleteGraphicRequest.new(login_for_test, 50)
    serv = InventoryService.new
    response = serv.delete_graphic(request)
    assert_not(ActiveStorageAttachments.where(blob_id: 50).nil?)
    assert(response.success)
  end

  test 'can handle nil existent blob id' do
    request = DeleteGraphicRequest.new(login_for_test, nil)
    serv = InventoryService.new
    response = serv.delete_graphic(request)
    assert_equal(response.message, 'Please send real blob id')
  end

  test 'can handle fake JWT on delete graphic request' do
    request = DeleteGraphicRequest.new(@@fake_token, 1)
    serv = InventoryService.new
    response = serv.delete_graphic(request)
    assert_equal(response.message, 'Error has occurred, unable to delete graphic')
  end
end
