# frozen_string_literal: true

# Inventory Service class
class InventoryService
  # @param [AddGraphicRequest] request
  # @return [AddGraphicResponse]
  def add_graphic(request)
    return AddGraphicResponse.new(false, 'Please Send Image') if request.image.nil?
    return AddGraphicResponse.new(false, 'Please send Type') if request.type.nil?

    decoded_token = JsonWebToken.decode(request.token)
    user = User.find_by_id(decoded_token['id'])
    @response = if user.nil?
                  AddGraphicResponse.new(false, 'User can not be found')
                else
                  user.graphic.attach(request.image)
                  blob = user.graphic.blobs.last
                  blob.metadata['type'] = request.type
                  blob.metadata
                  blob.save!
                  # TODO: change metadata before upload
                  AddGraphicResponse.new(true, 'Graphic been added')
                end
  rescue StandardError
    AddGraphicResponse.new(false, 'Error has occurred')
  end

  # @param [GetGraphicsRequest] request
  # @return [GetGraphicsResponse]
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
                      type: blob.metadata['type']
                    }
                  end
                  GetGraphicsResponse.new(true, 'User Inventory Graphics Obtained', image)
                end
  rescue StandardError
    GetGraphicsResponse.new(false, 'Error has occurred', nil)
  end

  # @param [DeleteGraphicRequest] request
  # @return [DeleteGraphicResponse]
  def delete_graphic(request)
    return DeleteGraphicResponse.new(false, 'Please Send Image') if request.blob_id < 1

    decoded_token = JsonWebToken.decode(request.token)
    user = User.find_by_id(decoded_token['id'])
    @response = if user.nil?
                  DeleteGraphicResponse.new(false, 'User can not be found')
                else
                  user.graphic.where(blob_id: request.blob_id).purge
                  DeleteGraphicResponse.new(true, 'Graphic been deleted')
                end
  rescue StandardError => e
    puts e
    DeleteGraphicResponse.new(false, 'Error has occurred, unable to delete graphic')
  end
end
