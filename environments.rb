require 'active_record'
require 'active_record_tasks'
require 'sinatra'

config_path = File.expand_path('../db/config.yml', __FILE__)
config = YAML.load_file(config_path)
env = ENV['RACK_ENV'] || 'development'

ActiveRecord::Base.establish_connection(config[env])
