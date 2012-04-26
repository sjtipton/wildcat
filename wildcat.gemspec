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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end