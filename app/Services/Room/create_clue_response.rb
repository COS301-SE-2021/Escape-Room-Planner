class CreateClueResponse

  def initialize(m,s)
    @message = m
    @success = s
  end

  #set method
  def setMessage(m)
    @message = m
  end

  #set method
  def setSuccess(s)
    @success = s
  end

  #get response Message
  def getMessage
    @message
  end

  #get success bool
  def isSuccess
    @success
  end
end