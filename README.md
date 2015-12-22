## Installation

Add this line to your application's Gemfile:

```ruby
gem 'payoneer-ruby'
```

And then execute:
  $ bundle

Or install it yourself as:
  $ gem install payoneer-ruby

## Usage

```ruby
configuration = Payoneer::Configuration.new(id: '...', username: '...', api_password: '...', environment: 'development')
client = Payoneer::Client.new(configuration)

client.status.body
=> "Echo Ok - All systems are up."

client.payee_signup_url('test').body
=> "https://payouts.sandbox.payoneer.com/partners/lp.aspx?token=6df65609ac89453fa11c3484755f891a3F410E6F56"

client.payee_register_format.body['Details'].keys
=> ["Country",
  "Currency",
  "BankAccountType",
  "BankName",
  "AccountName",
  "AccountNumber",
  "RoutingNumber",
  "AccountType"]

client.payee_register({
  apuid: 'test',
  RegistrationMode: '0',
  firstName: 'Foo',
  lastName: 'Bar',
  dateOfBirth: '09/20/1982',
  address1: '123 Main Street',
  address2: '',
  city: 'Palo Alto',
  country: 'US',
  state: 'CA',
  zipCode: '94306',
  phone: '707-849-7492',
  email: 'foo@bar.com',
  TransferMethod: {
    Type: '7',
    Details: {
      Country: 'US',
      Currency: 'USD',
      BankAccountType: '1',
      BankName: 'Wells Fargo',
      RoutingNumber: '121042882',
      AccountName: 'Foo Bar',
      AccountType: 'S',
      AccountNumber: '123456789'
    }
  }
}.to_xml(root: 'Details')).body
=> "OK (Request accepted)"

client.payee_details('test').body
=> {"FirstName"=>"Foo",
  "LastName"=>"Bar",
  "Email"=>"foo@bar.com",
  "Address1"=>"201 Valley Street",
  "Address2"=>nil,
  "City"=>"Los Altos",
  "State"=>"CA",
  "Zip"=>"94022",
  "Country"=>"US",
  "Phone"=>"707-849-7492",
  "Mobile"=>nil,
  "PayeeStatus"=>"InActive",
  "PayOutMethod"=>"Direct Deposit",
  "RegDate"=>"12/21/2015 8:03:19 PM",
  "PayoutMethodDetails"=>
   {"Currency"=>"USD",
    "Country"=>"US",
    "BankAccountType"=>"Individual",
    "BankName"=>"Wells Fargo",
    "AccountName"=>"Foo Bar",
    "AccountNumber"=>"123456789",
    "RoutingNumber"=>"121042882",
    "AccountType"=>"S"}}

client.payee_report('test').body
=> {"PayeeId"=>"test",
  "Name"=>"Foo Bar",
  "Email"=>"foo@bar.com",
  "RegistrationDate"=>"12/21/2015 8:03:19 PM",
  "Status"=>"Pending Approval",
  "TotalAmount"=>"0.00"}
```

## Development

After checking out the repo, run `bin/console` for an interactive prompt that will allow you to experiment.
