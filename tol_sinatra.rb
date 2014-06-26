require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative './lib/tree_of_life.rb'

set :bind, '0.0.0.0'
set :environment, :development

get '/node-attributes' do
  @node_name = params[:name]
  puts @node_name
  result = TreeOfLife::GetSpeciesData.new.run(@node_name)
  p result[:success?]
  content_type :json
  result[:species].to_json
end

get '/' do
  erb :index
end
