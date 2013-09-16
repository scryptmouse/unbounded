# encoding: utf-8

require "bundler/gem_tasks"

require "rspec/core/rake_task"
require 'yard'

RSpec::Core::RakeTask.new('spec')

desc 'Generate docs'
YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = ['lib/**/*.rb']
  t.options = ['--protected', '--private', '-r', 'README.md']
end

namespace :doc do
  desc 'Generate and publish YARD docs to github pages.'
  task :publish => ['doc'] do
    Dir.chdir(File.dirname(__FILE__) + '/../doc') do
      system %Q{git add .}
      system %Q{git add -u}
      system %Q{git commit -m 'Generating docs for version #{version}.'}
      system %Q{git push origin gh-pages}
    end
  end
end

task :default => :spec
