# -*- encoding: utf-8 -*-
# stub: method_source 0.8.2 ruby lib

Gem::Specification.new do |s|
  s.name = "method_source".freeze
  s.version = "0.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["John Mair (banisterfiend)".freeze]
  s.date = "2013-07-27"
  s.description = "retrieve the sourcecode for a method".freeze
  s.email = "jrmair@gmail.com".freeze
  s.homepage = "http://banisterfiend.wordpress.com".freeze
  s.rubygems_version = "3.4.20".freeze
  s.summary = "retrieve the sourcecode for a method".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bacon>.freeze, ["~> 1.1.0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 0.9"])
end
