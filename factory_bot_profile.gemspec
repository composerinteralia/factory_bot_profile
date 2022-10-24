# frozen_string_literal: true

require_relative "lib/factory_bot_profile/version"

Gem::Specification.new do |spec|
  spec.name = "factory_bot_profile"
  spec.version = FactoryBotProfile::VERSION
  spec.authors = ["Daniel Colson"]
  spec.email = ["danieljamescolson@gmail.com"]

  spec.summary = "Profiling for factory_bot"
  spec.homepage = "https://github.com/composerinterali/factory_bot_profile"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

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

  spec.add_dependency "factory_bot", ">= 6.2.1"
end
