$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rhinoart/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rhinoart"
  s.version     = Rhinoart::VERSION
  s.authors     = ["Konstantin Chernyaev", "Ivan Rudskikh"]
  s.email       = ["kch@list.ru", "shredder.rull@gmail.com"]
  s.homepage    = "https://github.com/shredder-rull/rhinoart_cms"
  s.summary     = "Rhinoart CMS"
  s.description = "Rhinoart CMS. This is a backend engine for making site"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  #s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '>= 5.0.0'
  s.add_dependency 'kaminari'
  s.add_dependency 'awesome_nested_set'
  s.add_dependency 'acts_as_list'

  s.add_dependency 'haml-rails'
  s.add_dependency 'slim'

  s.add_dependency 'bootstrap-will_paginate'
  s.add_dependency 'bootstrap-datepicker-rails'
  s.add_dependency 'russian', '~> 0.6.0'
  
  s.add_dependency 'mini_magick'
  s.add_dependency 'carrierwave'

  s.add_dependency 'devise'
  s.add_dependency 'cancan'
  s.add_dependency 'rolify'

  s.add_dependency 'paper_trail'
  s.add_dependency 'ransack'

  # s.add_dependency 'globalize', '>= 5.1.0'
  # s.add_dependency 'globalize-versioning'
  # s.add_dependency 'globalize-accessors'

  s.add_dependency 'cache_method'
  s.add_dependency 'nokogiri'

  s.add_dependency 'font-awesome-sass', '~> 4.7.0'
  s.add_dependency 'bootstrap', '~> 4.0.0.alpha6'
  s.add_dependency 'momentjs-rails', '>= 2.9.0'
  s.add_dependency 'bootstrap3-datetimepicker-rails', '~> 4.17.47'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'database_cleaner'
end
