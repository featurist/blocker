# Blocker

A little HTTP proxy that blocks access to external URLs based on regular expressions. Plug a browser or other HTTP client into blocker to 'short-curcuit' requests to particular URLs.

### Why?

Because web pages load faster by blocking requests to third-party domains, static assets, particular scripts, etc.

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
