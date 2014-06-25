require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative './lib/tree_of_life.rb'

set :bind, '0.0.0.0'
set :environment, :production

get '/node-attributes' do
  @node_name = params[:name]
  result = TreeOfLife::GetSpeciesData.new.run(@node_name)
  content_type :json
  result[:species].to_json
end
