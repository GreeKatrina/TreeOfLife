require 'sinatra'
require 'sinatra/reloader'
require_relative '.lib/tree_of_life.rb'

get '/node-attributes/' do
  @node_id = params[:id]

end
