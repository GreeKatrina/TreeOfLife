require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative './lib/tree_of_life.rb'

# Figure out what kind of environment to run in - dev is the default
ENV['APP_ENV'] ||= (ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development')

# Grab config data from the config file
db_config = YAML.load_file(File.expand_path('../../../db/config.yml', __FILE__))

set :bind, '0.0.0.0'
set :environment, ENV['APP_ENV']

get '/node-attributes' do
  @node_id = params[:id]
  puts @node_id
  result = TreeOfLife::GetSpeciesData.new.run(@node_id)
  p result[:success?]
  content_type :json
  result[:species].to_json
end

get '/' do
  erb :index
end

after do
  ActiveRecord::Base.clear_active_connections! if settings.development?
end
