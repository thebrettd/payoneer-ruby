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

client.status
 => #<Payoneer::Response:0x007f977d4882c8
  @body="Echo Ok - All systems are up.",
  @code="000">

client.payee_signup_url('payee_1')
 => #<Payoneer::Response:0x007f848bb76f08
  @body="https://payouts.sandbox.payoneer.com/partners/lp.aspx?token=f119cbf61614437bb29f15b5214d7c9d30FC9AC611",
  @code="000">

client.payee_details('test8380469')
 => #<Payoneer::Response:0x000000038e9308
  @body=
   {"FirstName"=>"Tophatter Galyna Test",
    "LastName"=>"Payoneer Bizops Test",
    "Email"=>"TophatterGalynaTest@mailinator.com",
    "Address1"=>"Hauptstrasse 5",
    "Address2"=>nil,
    "City"=>"Vienna",
    "State"=>nil,
    "Zip"=>"10110",
    "Country"=>"AT",
    "Phone"=>nil,
    "Mobile"=>"43456789789",
    "PayeeStatus"=>"Active",
    "PayOutMethod"=>"PayoneerAccount",
    "PayoutMethodDetails"=>{"ActivationStatus"=>"Activated"},
    "RegDate"=>"11/22/2015 8:03:18 AM"}
```

## Development

After checking out the repo, run `bin/console` for an interactive prompt that will allow you to experiment.
