require 'rubygems'
require 'selenium-webdriver'
require_relative '../../lib/blocker/proxy'

module Blocker

  describe Blocker do

    before :all do
      @teapots = Blocker::Proxy.new /418/
      @teapots.start

      profile = Selenium::WebDriver::Firefox::Profile.new
      profile.proxy = Selenium::WebDriver::Proxy.new(
        :http  => @teapots.host_and_port
      )
      @driver = Selenium::WebDriver.for :firefox, :profile => profile
    end

    after :all do
      @driver.quit
      @teapots.stop
    end

    context "when the URL matches the pattern" do

      it "allows the requests to proceed" do
        @driver.navigate.to 'http://httpbin.org/status/418'
        @driver.page_source.should_not include "// BLOCKED"
      end

    end

    context "when the URL does not match the pattern" do

      context "and the remote server would respond with a 200" do

        it "blocks the request" do
          @driver.navigate.to 'http://httpbin.org/status/200'
          @driver.page_source.should include "// BLOCKED"
        end

      end

      context "and the URL does not exist" do

        it "blocks the request" do
          @driver.navigate.to 'http://does-not-exist'
          @driver.page_source.should include "// BLOCKED"
        end

      end

    end

  end

end