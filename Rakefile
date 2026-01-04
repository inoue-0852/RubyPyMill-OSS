require "rake"

desc "Run RuboCop"
task :lint do
  sh "bundle exec rubocop"
end

desc "Run tests"
task :spec do
  sh "bundle exec rspec"
end

task default: [:lint, :spec]