# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

## 1.0.0

* Support Rails 6.1.
* Support Logux protocol v3 (breaking change, Logux.config.password is renamed to Logux.config.secret).

## 0.2
* Core Logux facilities are moved to `logux-rack` gem.
* `Logux::Actions` is soft-deprecated. Please use `Logux::Action` from now on.
* `Logux::Model::UpdatesDeprecator` is now coupled with `Logux::ActionCaller` via Logux configuration.

## 0.1.1
* Rails 6.0 support.

## 0.1
* Initial release.
