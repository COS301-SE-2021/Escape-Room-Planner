class SetUpOrderResponse
  attr_accessor :order, :status

  def initialize(order, status)
    @status = status
    @order = order
  end
end
