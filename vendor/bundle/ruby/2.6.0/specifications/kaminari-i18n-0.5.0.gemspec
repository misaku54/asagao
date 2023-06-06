# -*- encoding: utf-8 -*-
# stub: kaminari-i18n 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "kaminari-i18n".freeze
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Christopher Dell".freeze]
  s.date = "2018-01-11"
  s.description = "Translations for the kaminari gem".freeze
  s.email = ["chris@tigrish.com".freeze]
  s.homepage = "".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.1".freeze
  s.summary = "Translations for the kaminari gem".freeze

  s.installed_by_version = "3.4.1" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<rails>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<kaminari>.freeze, [">= 0"])
  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.6"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
  s.add_development_dependency(%q<i18n-spec>.freeze, [">= 0"])
  s.add_development_dependency(%q<localeapp>.freeze, [">= 0"])
end
