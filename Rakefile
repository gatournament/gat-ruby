VERSION = "0.0.1"

def colorize(text, color)
  color_codes = {
    :black    => 30,
    :red      => 31,
    :green    => 32,
    :yellow   => 33,
    :blue     => 34,
    :magenta  => 35,
    :cyan     => 36,
    :white    => 37
  }
  code = color_codes[color]
  if code == nil
    text
  else
    "\033[#{code}m#{text}\033[0m"
  end
end

task :clean => [] do
  sh "rm -rf ~*"
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'test'
end
# task :tests => [] do
# end

task :tag => [:tests] do
  sh "git tag #{VERSION}"
  sh "git push origin #{VERSION}"
end

task :reset_tag => [] do
  sh "git tag -d #{VERSION}"
  sh "git push origin :refs/tags/#{VERSION}"
end

task :package => [:tests] do
  sh "gem build gat_ruby.gemspec"
end

task :publish => [:tests, :package, :tag] do
  sh "curl -u qrush https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials"
  sh "gem push gat_ruby-#{VERSION}.gem"
end

task :all => [:dev_env, :dependencies, :tests]

task :default => [:tests]