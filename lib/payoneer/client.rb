module Payoneer
  class Client

    attr_accessor :configuration

    def initialize(configuration)
      @configuration = configuration
      @configuration.validate!
    end

    def status
      response = Payoneer.make_api_request('Echo')
      Response.new(response['Status'], response['Description'])
    end

    def self.payee_signup_url(payee_id, redirect_url: nil, redirect_time: nil)
      payoneer_params = {
        p4: payee_id,
        p6: redirect_url,
        p8: redirect_time,
        p9: Payoneer.configuration.auto_approve_sandbox_accounts?,
        p10: true
      }

      response = Payoneer.make_api_request('GetToken', payoneer_params)

      if success?(response)
        Response.new_ok_response(response['Token'])
      else
        Response.new(response['Code'], response['Description'])
      end
    end

    def self.payee_register_format(type, country, currency)
      payoneer_params = {
        Type: type, # 1, 2, 3, ..., 7
        Country: country, # 'US'
        Currency: currency # 'USD'
      }

      response = Payoneer.make_api_request('GetRegisterPayeeFormat', payoneer_params)

      if success?(response)
        Response.new_ok_response(response['TransferMethod'])
      else
        Response.new(response['Code'], response['Description'])
      end
    end

    def self.payee_register(xml)
      response = Payoneer.make_api_request('RegisterPayee', { Xml: xml })

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

      response = Payoneer.make_api_request('GetSinglePayeeReport', payoneer_params)

      if success?(response)
        Response.new_ok_response(response[response.keys.first]['payee']) # Top level key can be "Prepaid" or ...
      else
        Response.new(response['Code'], response['Description'])
      end
    end

    def payout(program_id:, payment_id:, payee_id:, amount:, description:, payment_date: Time.now, currency: 'USD')
      payoneer_params = {
        p4: program_id,
        p5: payment_id,
        p6: payee_id,
        p7: '%.2f' % amount,
        p8: description,
        p9: payment_date.strftime('%m/%d/%Y %H:%M:%S'),
        Currency: currency
      }
      response = Payoneer.make_api_request('PerformPayoutPayment', payoneer_params)
      Response.new(response['Status'], response['Description'])
    end

    private

    def api_request(method_name, params = {})
      request_params = default_params.merge(mname: method_name).merge(params)
      response = RestClient.post(configuration.api_url, request_params)
      fail Errors::UnexpectedResponseError.new(response.code, response.body) unless response.code == 200
      hash_response = Hash.from_xml(response.body)
      hash_response.values.first
    end

    def default_params
      {
        p1: configuration.partner_username,
        p2: configuration.partner_api_password,
        p3: configuration.partner_id,
      }
    end

    def success?(response)
      !response.has_key?('Code')
    end

  end
end
