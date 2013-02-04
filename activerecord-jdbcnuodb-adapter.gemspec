# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name = 'activerecord-jdbcnuodb-adapter'
  spec.version = '0.1'
  spec.date = '2013-10-07'

  spec.platform = Gem::Platform.new([nil, "java", nil])
  spec.rubyforge_project = %q{jruby-extras}

  spec.summary = "ActiveRecord adapter for NuoDB."
  spec.description = "ActiveRecord adapter for NuoDB. Only for use with JRuby. Requires separate Cache JDBC driver."

  spec.authors = ["Dave Meppelink", "Robert Buck"]
  spec.email = 'rbuck@nuodb.com'
  spec.homepage = 'http://jruby-extras.rubyforge.org/activerecord-jdbc-adapter'
  spec.require_paths = %w[lib]
  spec.rdoc_options = %w(--charset=UTF-8)
  spec.extra_rdoc_files = %w[README.md LICENSE]

  spec.files = `git ls-files`.split($\)

  spec.test_files = spec.files.select { |path| path =~ /^test\/.*test.*\.rb/ }

  spec.add_dependency(%q<activerecord-jdbc-adapter>, [">= 1.0.0"])

  spec.rubygems_version = %q{1.3.7}
  spec.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if spec.respond_to? :required_rubygems_version=
  if spec.respond_to? :specification_version
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    spec.specification_version = 3
  end
end
