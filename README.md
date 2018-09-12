# LoguxRails

[![Build Status](https://travis-ci.org/wilddima/logux_rails.svg?branch=master)](https://travis-ci.org/wilddima/logux_rails)

[![Coverage Status](https://coveralls.io/repos/github/wilddima/logux_rails/badge.svg?branch=master)](https://coveralls.io/github/wilddima/logux_rails?branch=master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logux_rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logux_rails

## Usage

First of all, you have to configure logux, by defining server address in, for example, `config/initializers/logux.rb`:

```ruby
Logux.configuration do |config|
  config.logux_host = 'http://localhost:3333'
end
```

Mount logux in routes:

```ruby
  mount Logux::Engine => '/'
```

After this, POST requests to `/logux` will be processed by LoguxController. You can redefine it or inherit from, if it necessary, for example, for implementing custom authorization flow.

LoguxRails will try to find Action for the specific message from logux-server. For example, for `project/rename` action, you should define `Action::Project` class, inherited from `Logux::Action` base class, and implement `rename` method.

## Todo

- Add permit method to logux params
- Add specs matchers, with mocks for requests and so on.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wilddima/logux_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LoguxRails project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/wilddima/logux_rails/blob/master/CODE_OF_CONDUCT.md).
