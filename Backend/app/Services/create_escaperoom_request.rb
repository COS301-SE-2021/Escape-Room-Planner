class CreateEscapeRoomRequest
  attr_accessor :name

  # later will need a user id to create
  def initialize(name)
    @name = name
  end
end
