# ruby_pymill.gemspec
require_relative "lib/ruby_pymill/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby_pymill"
  spec.version       = RubyPyMill::VERSION
  spec.authors       = ["Hiroshi Inoue"]
  spec.email         = ["hiroshi.inoue@gmail.com"]
  spec.summary       = "Run Jupyter Notebooks from Ruby using Papermill"
  spec.description   = "Ruby orchestrator to filter/execute tagged Jupyter cells via Papermill."
  spec.homepage      = "https://github.com/inoue-0852/RubyPyMill"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0"

  # 重要: vendor配下などは含めない
  spec.files = Dir.chdir(__dir__) do
    Dir["lib/**/*", "bin/*", "README.md", "LICENSE"]
  end

  spec.bindir        = "bin"
  spec.executables   = ["ruby_pymill"]
  spec.require_paths = ["lib"]

  # ランタイム依存（Ruby標準に近いが明示）
  spec.add_runtime_dependency "json", ">= 2.0"
end
