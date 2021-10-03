# frozen_string_literal: true

# Request for delete graphic feature
class DeleteGraphicRequest
  attr_accessor :token, :blob_id

  def initialize(token, blob_id)
    @token = token
    @blob_id = blob_id
  end
end
