# -*- encoding: utf-8 -*-
# stub: notiffany 0.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "notiffany".freeze
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Cezary Baginski".freeze]
  s.date = "2015-02-19"
  s.description = "Single wrapper for most popular notification libraries".freeze
  s.email = ["cezary@chronomantic.net".freeze]
  s.homepage = "".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Notifier library (extracted from Guard project)".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<nenv>.freeze, ["~> 0.1"])
  s.add_runtime_dependency(%q<shellany>.freeze, ["~> 0.0"])
  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
end
