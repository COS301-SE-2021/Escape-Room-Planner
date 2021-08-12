class SetUpOrderResponse
  attr_accessor :order

  def initialize(order, status)
    @status = status
    @order = order
  end
end
