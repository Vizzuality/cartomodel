$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'cartomodel/version'

Gem::Specification.new do |s|
  s.name          = "cartomodel"
  s.version       = Cartomodel::VERSION
  s.authors       = ["Tiago Garcia"]
  s.email         = ["tiagojsag@gmail.com"]

  s.summary       = "CartoDB sync for ActiveRecord objects"
  s.description   = "CartoDB sync for ActiveRecord objects"
  s.homepage      = "http://vizzuality.com"
  s.license      = "MIT"


  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.require_paths  = ["lib"]

  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rspec-expectations"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rake"

  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "activerecord"
  s.add_runtime_dependency "arel"
  s.add_runtime_dependency "cartowrap"
end