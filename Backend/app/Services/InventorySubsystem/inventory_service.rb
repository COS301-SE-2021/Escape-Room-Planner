# frozen_string_literal: true

# Inventory Service class
class InventoryService
  # @param [AddGraphicRequest] request
  # @return [AddGraphicResponse]
  def add_graphic(request)
    AddGraphicResponse.new(false, 'Please Send Image') if request.image.nil?

    decoded_token = JsonWebToken.decode(request.token)
    user = User.find_by_id(decoded_token['id'])
    @response = if user.nil?
                  AddGraphicResponse.new(false, 'User can not be found')
                else
                  user.graphic.attach(request.image)
                  AddGraphicResponse.new(true, 'Graphic been added')
                end
  rescue StandardError
    AddGraphicResponse.new(false, 'Error has occurred')
  end
end
