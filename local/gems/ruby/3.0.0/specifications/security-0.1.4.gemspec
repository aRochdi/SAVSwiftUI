# -*- encoding: utf-8 -*-
# stub: security 0.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "security".freeze
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mattt".freeze]
  s.date = "2021-03-02"
  s.email = "mattt@me.com".freeze
  s.homepage = "https://mat.tt/".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.3".freeze
  s.summary = "Interact with the macOS Keychain".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake>.freeze, ["~> 12.3", ">= 12.3.3"])
  else
    s.add_dependency(%q<rake>.freeze, ["~> 12.3", ">= 12.3.3"])
  end
end
