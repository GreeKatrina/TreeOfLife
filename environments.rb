require 'active_record'
require 'active_record_tasks'
require 'sinatra'

config_path = File.expand_path('../db/config.yml', __FILE__)
config = YAML.load ERB.new(File.read config_path).result
env = ENV['RACK_ENV'] || 'development'

ActiveRecord::Base.establish_connection(config[env])
