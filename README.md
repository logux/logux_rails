# Logux Rails

[![Build Status](https://travis-ci.org/logux/logux_rails.svg?branch=master)](https://travis-ci.org/logux/logux_rails) [![Coverage Status](https://coveralls.io/repos/github/logux/logux_rails/badge.svg?branch=master)](https://coveralls.io/github/logux/logux_rails?branch=master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logux_rails'
```

And then execute:

```bash
bundle
```

## Usage

First of all, you have to configure Logux, by defining server address in, for example, `config/initializers/logux.rb`:

```ruby
Logux.configuration do |config|
  config.logux_host = 'http://localhost:31338'
end
```

Mount logux in routes:

```ruby
  mount Logux::Engine => '/'
```

After this, POST requests to `/logux` will be processed by `LoguxController`. You can redefine it or inherit from, if it necessary, for example, for implementing custom authorization flow.

Logux Rails will try to find Action for the specific message from Logux Server. For example, for `project/rename` action, you should define `Action::Project` class, inherited from `Logux::Action` base class, and implement `rename` method.

You can execute `rake logux:actions` to get the list of available action types, or `rake logux:channels` to get the list of available channels.

## Development with Docker

After checking out the repo, run:

```bash
docker-compose run app bundle install
docker-compose run app bundle exec appraisal install
```

Run tests with:

```bash
docker-compose run app bundle exec appraisal rspec
```

Run RuboCop with:

```bash
docker-compose run app bundle exec rubocop
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
