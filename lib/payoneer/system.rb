module Payoneer
  class System
    STATUS_METHOD_NAME = 'Echo'

    def self.status
      response = Payoneer.make_api_request(STATUS_METHOD_NAME)
      Response.new(response['Status'], response['Description'])
    end
  end
end
