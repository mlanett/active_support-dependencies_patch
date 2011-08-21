# -*- encoding: utf-8 -*-
x = File.expand_path( File.join( File.dirname(__FILE__), "lib" ) )
$:.push x unless $:.member?(x)
require "active_support/dependencies_patch/version"

Gem::Specification.new do |s|
  s.name        = "active_support-dependencies_patch"
  s.version     = ActiveSupport::DependenciesPatch::VERSION
  s.authors     = ["Mark Lanett"]
  s.email       = ["mark.lanett@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Allow gems to provide models which are then extended by the app}

  s.rubyforge_project = "active_support-dependencies_patch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
