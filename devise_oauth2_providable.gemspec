# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise/oauth2_providable/version"

Gem::Specification.new do |s|
  s.name        = "anjlab-devise-oauth2-providable"
  s.version     = Devise::Oauth2Providable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Sonnek"]
  s.email       = ["ryan@socialcast.com"]
  s.homepage    = "https://github.com/anjlab/devise_oauth2_providable"
  s.summary     = %q{OAuth2 Provider for Rails3 applications with Devise 2.1.0}
  s.description = %q{Rails3 engine that adds OAuth2 Provider support to any application built with Devise authentication}

  s.add_runtime_dependency "rails", ">= 3.2.0"
  s.add_runtime_dependency "devise", ">= 2.1.0"
  s.add_runtime_dependency "rack-oauth2", "~> 0.14.4"

  s.add_development_dependency "rspec-rails", '>= 2.6.2'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "shoulda-matchers", ">=1.0.0"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "factory_girl_rspec", '>= 0.0.1'
  s.add_development_dependency "rake", '>= 0.9.2.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
