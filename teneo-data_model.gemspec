# frozen_string_literal: true

require_relative "lib/teneo/data_model/version"

Gem::Specification.new do |spec|
  spec.name = "teneo-data_model"
  spec.version = Teneo::DataModel::VERSION
  spec.authors = ["Kris Dekeyser"]
  spec.email = ["kris.dekeyser@kuleuven.be"]

  spec.summary = "Data Model classes for Teneo"
  spec.description = "This gem provides a library with all the Data Model classes for Teneo"
  spec.homepage = "https://github.com/LIBIS/teneo-data_model"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/libis"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/LIBIS/teneo-data_model"
  spec.metadata["changelog_uri"] = "https://github.com/LIBIS/teneo-data_model/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "net-ftp"
  
  spec.add_runtime_dependency "sequel", "~> 5.58"
  spec.add_runtime_dependency "pg"
  spec.add_runtime_dependency "sequel_pg"

  spec.add_runtime_dependency "dotenv"
  spec.add_runtime_dependency "dry-configurable"
  spec.add_runtime_dependency "dry-types"
  spec.add_runtime_dependency "dry-struct"
  spec.add_runtime_dependency "method_source"
  spec.add_runtime_dependency "sequel_secure_password"
  spec.add_runtime_dependency "sequel-seed"

  spec.add_runtime_dependency "teneo-tools"
  spec.add_runtime_dependency "teneo-storage_driver"
end
