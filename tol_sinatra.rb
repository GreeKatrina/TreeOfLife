require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative './lib/tree_of_life.rb'

set :bind, '0.0.0.0'
set :environment, :development

get '/node-attributes' do
  @node_id = params[:id]
  result = TreeOfLife::GetSpeciesData.new.run(@node_id)
  content_type :json
  result.to_json
end

get '/' do
  erb :index
end
