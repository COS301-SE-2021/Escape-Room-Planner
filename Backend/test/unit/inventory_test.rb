# frozen_string_literal: true

require 'test_helper'
require './app/Services/InventorySubsystem/inventory_service'
require './app/Services/InventorySubsystem/Request/add_graphic_request'
require './app/Services/InventorySubsystem/Response/add_graphic_response'

# Class that test inventory sub system
class InventoryTest < ActiveSupport::TestCase
  @@TOKEN = 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoyMzg2MDczMjMxfQ.Zwe1E5JKM40pXWoVgUaqcVsc5mPFt7HHj2k6f3WZZr0'

  test 'can add Graphic to Inventory' do
    request = AddGraphicRequest.new(@@TOKEN, "won")
    serv = InventoryService.new
    response = serv.add_graphic(request)
    puts response.message
  end
end