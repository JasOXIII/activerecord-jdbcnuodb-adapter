# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$:.push lib unless $:.include?(lib)
require 'activerecord-jdbcnuodb-adapter'

Gem::Specification.new do |spec|
  spec.name             = 'activerecord-jdbcnuodb-adapter'
  spec.version          = ArJdbc::NuoDB::VERSION
  spec.authors          = ['Robert Buck', 'Dave Meppelink']
  spec.email            = 'rbuck@nuodb.com'
  spec.description      = 'ActiveRecord adapter for NuoDB. Only for use with JRuby. Requires separate Cache JDBC driver.'
  spec.summary          = 'ActiveRecord adapter for NuoDB.'
  spec.homepage         = 'http://jruby-extras.rubyforge.org/activerecord-jdbc-adapter'
  spec.license          = 'BSD'

  spec.require_paths    = %w[lib]
  spec.rdoc_options     = %w(--charset=UTF-8)

  spec.files            = `git ls-files`.split($\)

  spec.test_files       = spec.files.select { |path| path =~ /^test\/.*test.*\.rb/ }

  spec.add_dependency 'jdbc-nuodb', '~> 2.0'
  spec.add_dependency 'activerecord-jdbc-adapter', '>= 1.0.0'

  %w(rake).each { |gem| spec.add_development_dependency gem }
  %w(rspec rspec-core rspec-expectations rspec-mocks).each { |gem| spec.add_development_dependency gem, '~> 2.11.0' }

  spec.rubygems_version = %q{1.3.7}
  spec.required_rubygems_version = Gem::Requirement.new('> 1.3.1') if spec.respond_to? :required_rubygems_version=
  if spec.respond_to? :specification_version
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    spec.specification_version = 3
  end
end
