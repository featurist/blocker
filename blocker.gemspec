# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'blocker/version'

Gem::Specification.new do |s|
  s.name = 'blocker'
  s.version = Blocker::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Josh Chisholm']
  s.email = ['josh@featurist.co.uk']
  s.homepage = 'http://github.com/featurist/blocker'
  s.summary = 'HTTP proxy that blocks URLs based on regular expressions'
  s.description = s.summary

  s.required_ruby_version = '>=1.9.2'

  s.add_dependency 'goliath', '>= 1.0.0'
  s.add_dependency 'em-http-request', '>= 1.0.3'
  
  s.add_development_dependency 'selenium-webdriver', '>= 2.33.0'
  s.add_development_dependency 'rspec'
  
  ignores = File.readlines(".gitignore").grep(/\S+/).map {|i| i.chomp }.map {|i| File.directory?(i) ? i.sub(/\/?$/, '/*') : i }
  dotfiles = [".gitignore"]

  s.files = Dir["**/*"].reject {|f| File.directory?(f) || ignores.any? {|i| File.fnmatch(i, f) } } + dotfiles
  s.test_files = s.files.grep(/^spec\//)
  s.require_paths = ['lib']
end