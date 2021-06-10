class CreateKeyResponse

  attr_accessor :id, :success

  def initialize(id, success)
    @id = id
    @success = success
  end

end