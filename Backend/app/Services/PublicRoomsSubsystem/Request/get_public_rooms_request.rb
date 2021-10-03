# frozen_string_literal: true

# request structure to know if public
class GetPublicRoomsRequest
  attr_accessor :search, :filter, :result_start, :result_end

  def initialize(search, filter, result_start, result_end)
    @search = search
    @filter = filter
    @result_start = result_start
    @result_end = result_end
  end
end
