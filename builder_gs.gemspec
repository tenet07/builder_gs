require_relative 'lib/builder_gs/version'

Gem::Specification.new do |spec|
  spec.name          = "builder_gs"
  spec.version       = BuilderGs::VERSION
  spec.authors       = ["Gunjan Solanki"]
  spec.email         = ["gunjan.solanki@builder.ai"]

  spec.summary       = %q{Builder GS is an interface to intereact with external APIs within application.}
  spec.description   = %q{Interface to connect external APIs}
  spec.homepage      = "https://github.com/tenet07/builder_gs"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tenet07/builder_gs"
  spec.metadata["changelog_uri"] = "https://github.com/tenet07/builder_gs"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
