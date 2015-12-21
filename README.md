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
configuration = Payoneer::Configuration.new do |c|
  c.environment = 'production'
  c.partner_id = '<payoneer_account_id>'
  c.partner_username = '<payoneer_account_username>'
  c.partner_api_password = '<payoneer_api_password>'
end

client = Payoneer::Client.new(configuration)

response = client.status
response.code
=> "000"
response.body
=> "Echo OK - All systems are up"
response.ok?
=> true

client.payee_signup_url('payee_1')
client.payee_signup_url('payee_1', redirect_url: 'http://<redirect_url>.com')
client.payee_signup_url('payee_1', redirect_url: 'http://<redirect_url>.com', redirect_time: 10)

response = client.payee_signup_url('payee_1')
response.ok?
signup_url = response.body

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
