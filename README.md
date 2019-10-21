# Logux Rails

[![Build Status](https://travis-ci.org/logux/logux_rails.svg?branch=master)](https://travis-ci.org/logux/logux_rails) [![Coverage Status](https://coveralls.io/repos/github/logux/logux_rails/badge.svg?branch=master)](https://coveralls.io/github/logux/logux_rails?branch=master)

Add WebSockets, live-updates and offline-first to Ruby on Rails with [Logux](https://github.com/logux/logux/). This gem will add [Logux Back-end Protocol](https://github.com/logux/logux/blob/master/backend-protocol/spec.md) to Ruby on Rails and then you can use Logux Server as a proxy between WebSocket and your Rails application.

Read [Creating Logux Proxy](https://github.com/logux/logux/blob/master/2-starting/2-creating-proxy.md) guide.

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

Mount `Logux::Rack` in your application routing configuration:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount Logux::Engine => '/'
end
```

After this, POST requests to `/logux` will be processed by `LoguxController`. You can redefine it or inherit from, if it necessary, for example, for implementing custom authorization flow.

Logux Rails will try to find Action for the specific message from Logux Server. For example, for `project/rename` action, you should define `Action::Project` class, inherited from `Logux::Action` base class, and implement `rename` method.

### Rake commands

Use `rails logux:actions` command to get the list of available action types, or `rails logux:channels` for channels. The default search path is set to `app/logux/actions` and `app/logux/channels` for actions and channels correspondingly, assuming `app` directory is the root of your Rails application. Both command support custom search paths: `rails logux:actions[lib/logux/actions]`.

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
