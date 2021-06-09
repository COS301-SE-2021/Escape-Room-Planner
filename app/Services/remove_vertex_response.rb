class RemoveVertexResponse

  attr_accessor :success, :message

  def initialize(success)
    @success = success
    @message = nil
  end

end