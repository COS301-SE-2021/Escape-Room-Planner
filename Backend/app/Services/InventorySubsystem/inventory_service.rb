# frozen_string_literal: true

# Inventory Service class
class InventoryService
  def add_graphic(request)
    decoded_token = JsonWebToken.decode(request.token)
  end
end
