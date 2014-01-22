# encoding: utf-8

require 'rubygems'

begin
  require 'bundler'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler."
  exit e.status_code
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems."
  exit e.status_code
end

require 'rake'
require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

task :test    => :spec
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new  
task :doc => :yard

desc "Fire up an interactive terminal to play with"
task :console do
  require 'pry'
  require 'yaml'
  require File.expand_path(File.dirname(__FILE__) + '/lib/contextio')

  config = YAML.load_file File.expand_path(File.dirname(__FILE__) + '/spec/config.yml')
  @api = ContextIO.new(config['key'], config['secret'])

  # add ability to reload console
  def reload
    reload_msg = '# Reloading the console...'
    puts CodeRay.scan(reload_msg, :ruby).term
    Pry.save_history
    exec('rake console')
  end

  welcome = <<-EOS
    Welcome to the Context.IO developer console. If you put your API credentials in
    /spec/config.yml, you'll have a handle on the API named `@api` to play with.
  EOS

  puts welcome
  Pry.start
end
