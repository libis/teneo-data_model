# frozen_string_literal: true

require_relative 'lib/teneo/data_model/version'

Gem::Specification.new do |spec|
  spec.name = 'teneo-data_model'
  spec.version = Teneo::DataModel::VERSION
  spec.authors = ['Kris Dekeyser']
  spec.email = ['kris.dekeyser@kuleuven.be']

  spec.summary = 'Data Model classes for Teneo'
  spec.description = 'This gem provides a library with all the Data Model classes for Teneo'
  spec.homepage = 'https://github.com/LIBIS/teneo-data_model'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.4.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/libis'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/LIBIS/teneo-data_model'
  spec.metadata['changelog_uri'] = 'https://github.com/LIBIS/teneo-data_model/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.glob('lib/**/*') + Dir.glob('teneo-data_model.gemspec') + Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '~> 8.0', '>= 8.0.2'
  spec.add_runtime_dependency 'csv', '~> 3.0', '>= 3.3.2'
  spec.add_runtime_dependency 'naturally', '~> 2.0', '>= 2.2.1'
  spec.add_runtime_dependency 'pg', '~> 1.0', '>= 1.5'
  spec.add_runtime_dependency 'sequel', '~> 5.0', '>= 5.76'
  spec.add_runtime_dependency 'sequel_pg', '~> 1.0', '>= 1.17.2'
  spec.add_runtime_dependency 'sequel_secure_password', '~> 0.0', '>= 0.2.15'
  spec.add_runtime_dependency 'sequel-seed', '~> 1.0', '>= 1.1'

  spec.add_runtime_dependency 'dotenv', '~> 3.0', '>= 3.1.7'
  spec.add_runtime_dependency 'dry-configurable', '~> 1.0', '>= 1.3.0'
  spec.add_runtime_dependency 'dry-struct', '~> 1.0', '>= 1.8.0'
  spec.add_runtime_dependency 'dry-types', '~> 1.0', '>= 1.8.2'
  spec.add_runtime_dependency 'method_source', '~> 1.0', '>= 1.1.0'

  spec.add_development_dependency 'nokogiri', '~> 1.0', '>= 1.18.4'
  spec.add_development_dependency 'rexml', '~> 3.0', '>= 3.4.1'
end
