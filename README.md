# Blocker

A little HTTP proxy that blocks access to external URLs based on regular expressions.

### Why?

Sometimes you want to stop your web browser or other client from downloading content or executing scripts from particular URLs, because it's faster.

### Install

* Install Ruby 1.9 or later (blocker is based on [goliath](https://github.com/postrank-labs/goliath))

*       gem install blocker

### Usage

    require 'blocker'

    proxy = Blocker::Proxy.new /418/
    proxy.start

    # curl --proxy 127.0.0.1:9876 httpbin.org/status/200
    # curl --proxy 127.0.0.1:9876 httpbin.org/status/418

    proxy.stop

### License

MIT license, for full details please see the LICENSE file.
