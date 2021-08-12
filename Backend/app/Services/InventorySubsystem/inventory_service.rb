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
                  blob = user.graphic.blobs.last
                  puts blob.metadata['identified']
                  AddGraphicResponse.new(true, 'Graphic been added')
                end
  rescue StandardError
    AddGraphicResponse.new(false, 'Error has occurred')
  end

  def get_graphics(request)
    decoded_token = JsonWebToken.decode(request.token)
    user = User.find_by_id(decoded_token['id'])
    @response = if user.nil?
                  GetGraphicsResponse.new(false, 'User can not be found', nil)
                else
                  image = user.graphic.blobs
                  image = image.map do |blob|
                    {
                      blob_id: blob.id,
                      src: Rails.application.routes.url_helpers.polymorphic_url(blob, host: 'localhost:3000'),
                      type: 'clue'
                    }
                  end
                  puts image
                  GetGraphicsResponse.new(true, 'User Inventory Graphics Obtained', image)
                end
  rescue StandardError
    GetGraphicsResponse.new(false, 'Error has occurred', nil)
  end
end
