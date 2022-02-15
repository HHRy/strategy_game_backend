# frozen_string_literal: true

require_relative 'lib/strategy_game_backend/version'

Gem::Specification.new do |spec|
  spec.name = 'strategy_game_backend'
  spec.version = StrategyGameBackend::VERSION
  spec.authors = ['Ryan Stenhouse']
  spec.email = ['ryan@ryanstenhouse.jp']

  spec.summary = 'Library for running a web-based C&C style strategy game'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/HHRy/strategy_game_backend'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/HHRy/strategy_game_backend'
  spec.metadata['changelog_uri'] = 'https://github.com/HHRy/strategy_game_backend/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'concurrent-ruby', '~> 1.1'
  spec.add_dependency 'pathfinding', '0.0.1'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
