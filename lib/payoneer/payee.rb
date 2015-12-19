module Payoneer
  class Payee
    SIGNUP_URL_API_METHOD_NAME = 'GetToken'
    REGISTER_PAYEE_FORMAT_API_METHOD_NAME = 'GetRegisterPayeeFormat'
    REGISTER_PAYEE_API_METHOD_NAME = 'RegisterPayee'
    PAYEE_REPORT_API_METHOD_NAME = 'GetSinglePayeeReport'

    def self.signup_url(payee_id, redirect_url: nil, redirect_time: nil)
      payoneer_params = {
        p4: payee_id,
        p6: redirect_url,
        p8: redirect_time,
        p9: Payoneer.configuration.auto_approve_sandbox_accounts?,
        p10: true
      }

      response = Payoneer.make_api_request(SIGNUP_URL_API_METHOD_NAME, payoneer_params)

      if success?(response)
        Response.new_ok_response(response['Token'])
      else
        Response.new(response['Code'], response['Description'])
      end
    end

    def self.register_payee_format(type, country, currency)
      payoneer_params = {
        Type: type, # 1, 2, 3, ..., 7
        Country: country, # 'US'
        Currency: currency # 'USD'
      }

      response = Payoneer.make_api_request(REGISTER_PAYEE_FORMAT_API_METHOD_NAME, payoneer_params)

      if success?(response)
        Response.new_ok_response(response['TransferMethod'])
      else
        Response.new(response['Code'], response['Description'])
      end
    end

    # Usage:
    # Payoneer::Payee.register_payee({
    #   apuid: ...,
    #   RegistrationMode: '0',
    #   firstName: ...,
    #   lastName: ...,
    #   dateOfBirth: ...,
    #   address1: ...,
    #   address2: ...,
    #   city: ...,
    #   country: ...,
    #   state: ...,
    #   zipCode: ...,
    #   phone: ...,
    #   email: ...,
    #   TransferMethod: {
    #     Type: '7',
    #     Details: {
    #       Country: 'US',
    #       Currency: 'USD',
    #       BankAccountType: '1',
    #       BankName: ...,
    #       RoutingNumber: ...,
    #       AccountName: ...,
    #       AccountType: ...,
    #       AccountNumber: ...
    #     }
    #   }
    # }.to_xml(root: 'Details'))
    def self.register_payee(xml)
      response = Payoneer.make_api_request(REGISTER_PAYEE_API_METHOD_NAME, { Xml: xml })

      if success?(response)
        Response.new_ok_response(response['PayeeId'])
      else
        Response.new(response['Code'], response['Description'])
      end
    end

    def self.payee_report(payee_id)
      payoneer_params = {
        p4: payee_id,
        p10: true
      }

      response = Payoneer.make_api_request(PAYEE_REPORT_API_METHOD_NAME, payoneer_params)

      if success?(response)
        Response.new_ok_response(response[response.keys.first]['payee']) # Top level key can be "Prepaid" or ...
      else
        Response.new(response['Code'], response['Description'])
      end
    end

    private

    def self.success?(response)
      !response.has_key?('Code')
    end

  end
end
