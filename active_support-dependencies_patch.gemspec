# -*- encoding: utf-8 -*-
x = File.expand_path( File.join( File.dirname(__FILE__), "lib" ) )
$:.push x unless $:.member?(x)
require "active_support-dependencies_patch/version"

Gem::Specification.new do |s|
  s.name        = "active_support-dependencies_patch"
  s.version     = ActiveSupport::DependenciesPatch::VERSION
  s.authors     = ["Mark Lanett"]
  s.email       = ["mark.lanett@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Allow gems to provide models which are then extended by the app}
  s.description = %q{Based on code at https://gist.github.com/910368#file_as_dependencies_patch.rb}
  
  s.rubyforge_project = "active_support-dependencies_patch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "activesupport"
  s.add_development_dependency "minitest"
end
