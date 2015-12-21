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
configuration = Payoneer::Configuration.new(id: '...', username: '...', api_password: '...')
client = Payoneer::Client.new(configuration)
client.status
=> #<Payoneer::Response:0x007f977d4882c8
 @body="Echo Ok - All systems are up.",
 @code="000">

client.payee_signup_url('payee_1')
=> #<Payoneer::Response:0x007f848bb76f08
 @body="https://payouts.sandbox.payoneer.com/partners/lp.aspx?token=f119cbf61614437bb29f15b5214d7c9d30FC9AC611",
 @code="000">

response = Payoneer::Payout.create(
  program_id: '<payoneer_program_id>',
  payment_id: 'payment_1',
  payee_id: 'payee_1',
  amount: 4.20,
  description: 'payee payout',
  payment_date: Time.now, #defaults to Time.now
  currency: 'USD' #defaults to USD
)
response.ok?
```

## Development

After checking out the repo, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
