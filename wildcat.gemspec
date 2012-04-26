# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wildcat/version"

Gem::Specification.new do |s|
  s.name        = "wildcat"
  s.version     = Wildcat::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Tipton"]
  s.email       = ["slaatipton26@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby Gem that exposes the wonderful goodness of the Pro Football API}
  s.description = %q{Ruby Gem that exposes the wonderful goodness of the Pro Football API}

  s.rubyforge_project = "wildcat"

  s.add_dependency(%q<rake>, ">= 0")
  s.add_dependency(%q<typhoeus>, ">= 0")
  s.add_dependency(%q<yajl-ruby>, ">= 0")
  s.add_dependency(%q<activemodel>, '~> 3.1.0')

  s.add_development_dependency('rspec', '~> 2.6')
  s.add_development_dependency('factory_girl', '~> 2.1.2')
  s.add_development_dependency('forgery', '0.3.12')
  s.add_development_dependency('shoulda-matchers')
  s.add_development_dependency('awesome_print')
  s.add_development_dependency('interactive_editor')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end