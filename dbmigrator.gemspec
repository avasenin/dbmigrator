# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dbmigrator"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrey Vasenin"]
  s.date = "2012-11-27"
  s.email = "vasenin@aboutecho.com"
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "Rakefile",
    "VERSION",
    "dbmigrator.gemspec",
    "example/.gitignore",
    "example/Rakefile",
    "lib/dbmigrator.rb",
    "lib/dbmigrator/minimal_rails_application.rb",
    "lib/dbmigrator/tasks/databases.rake",
    "lib/dbmigrator/tasks/migration_generator.rb",
    "lib/dbmigrator/tasks/postgres.rb",
    "lib/dbmigrator/tasks/task_manager.rb"
  ]
  s.homepage = "http://github.com/avasenin/dbmigrator"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Standalone migrator for non Rails projects"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, ["~> 3.2.9"])
      s.add_runtime_dependency(%q<railties>, ["~> 3.2.9"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<activerecord>, ["~> 3.2.9"])
      s.add_dependency(%q<railties>, ["~> 3.2.9"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<activerecord>, ["~> 3.2.9"])
    s.add_dependency(%q<railties>, ["~> 3.2.9"])
  end
end

