Gem::Specification.new do |spec|
  spec.name = "fspec"
  spec.version = "0.0.1"
  spec.summary = "Runs RSpec suite multiple times to find flaky tests."
  spec.authors = ["João Pimentel"]
  spec.license = "MIT"
  spec.homepage = "https://github.com/jfpimentel/fspec"

  spec.files = Dir.glob("lib/**/*")
  spec.executables = ["fspec"]

  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
end
