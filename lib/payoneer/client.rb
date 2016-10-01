module Payoneer
  class Client

    attr_accessor :configuration

    def initialize(configuration)
      @configuration = configuration
      @configuration.validate!
    end

    def status
      api_request('Echo')
    end

    def version
      api_request('GetVersion')
    end

    def account
      api_request('GetAccountDetails')
    end

    def payee_signup_url(payee_id, redirect_url: nil, redirect_time: nil)
      api_request('GetToken', p4: payee_id, p6: redirect_url, p8: redirect_time, p9: configuration.auto_approve_sandbox_accounts?, p10: true) do |response|
        response['Token']
      end
    end

    def payee_register_format(type = '7', country = 'US', currency = 'USD')
      api_request('GetRegisterPayeeFormat', Type: type, Country: country, Currency: currency) do |response|
        response['TransferMethod']
      end
    end

    def payee_register(xml)
      api_request('RegisterPayee', Xml: xml) do |response|
        response['PayeeId']
      end
    end

    def payee_edit(xml)
      api_request('EditTransferMethod', Xml: xml) do |response|
        response['PayeeId']
      end
    end

    def payee_details(payee_id)
      api_request('GetPayeeDetails', p4: payee_id, p10: true) do |response|
        response['CompanyDetails'].present? ? response['Payee'].merge(response['CompanyDetails']) : response['Payee']
      end
    end

    def payee_report(payee_id)
      api_request('GetSinglePayeeReport', p4: payee_id, p10: true) do |response|
        response[response.keys.first]['payee']
      end
    end

    # ChangePayeeID
    # GetPayeesReport
    # GetUnclaimedPaymentsXML
    # GetUnclaimedPaymentsCSV
    # CancelPayment

    def payout(program_id:, payment_id:, payee_id:, amount:, description:, payment_date: Time.now, currency: 'USD')
      amount       = '%.2f' % amount
      payment_date = payment_date.strftime('%m/%d/%Y %H:%M:%S')
      api_request('PerformPayoutPayment', p4: program_id, p5: payment_id, p6: payee_id, p7: amount, p8: description, p9: payment_date, Currency: currency)
    end

    def payout_details(payee_id:, payment_id:)
      api_request('GetPaymentStatus', p4: payee_id, p5: payment_id)
    end

    private

    def api_request(method_name, params = {}, &block)
      response = RestClient.post(configuration.api_url, {
        mname: method_name,
        p1: configuration.partner_username,
        p2: configuration.partner_api_password,
        p3: configuration.partner_id
      }.merge(params))

      if response.code != 200
        fail Errors::UnexpectedResponseError.new(response.code, response.body)
      end

      hash = Hash.from_xml(response.body).values.first

      if hash.has_key?('Code')
        Response.new(hash['Code'], hash['Description'])
      else
        hash = if block_given?
          yield(hash)
        else
          hash
        end

        Response.new_ok_response(hash)
      end
    end

  end
end
