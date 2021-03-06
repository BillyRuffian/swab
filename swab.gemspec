lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "swab/version"

Gem::Specification.new do |spec|
  spec.name          = "swab"
  spec.version       = Swab::VERSION
  spec.authors       = ["Nigel Brookes-Thomas"]
  spec.email         = ["nigel@brookes-thomas.co.uk"]

  spec.summary       = %q{Scrape the nursing schedule}
  spec.homepage      = "https://github.com"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.12"
  
  spec.add_runtime_dependency 'mechanize', '~> 2.7'
  spec.add_runtime_dependency 'slop', '~> 4.0'
  spec.add_runtime_dependency 'tty-spinner', '~> 0.9'
end
