require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/base'
require 'json'
require_relative './lib/tree_of_life.rb'

set :bind, '0.0.0.0'
set :environment, :production

  get '/node-attributes' do
    @node_id = params[:id]
    result = TreeOfLife::GetSpeciesData.new.run(@node_id)
    content_type :json
    result.to_json
  end

  get '/' do
    erb :index
  end

  after do
    ActiveRecord::Base.clear_active_connections! if settings.development?
  end
