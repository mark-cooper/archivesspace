# frozen_string_literal: true

source 'https://rubygems.org'

# Gemfile for supporting rake tasks
gem 'http'
gem 'git'
gem 'github_api'
gem 'json'
gem 'rake'

# echo "jruby-9.2.20.1" > .ruby-version
# bundle install --with debug --without default build/gems
group :debug do
  gem 'ruby-debug-base'
  gem 'ruby-debug-ide'
end

group :rubocop do
  gem 'rubocop'
end
