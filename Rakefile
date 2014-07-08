require 'active_record_tasks'
require './lib/tree_of_life.rb'
require 'sinatra'

set :environment, :development, :production

ActiveRecordTasks.configure do |config|
  # These are all the default values
  config.db_dir = 'db'
  config.db_config_path = 'db/config.yml'
  config.env = ENV['RACK_ENV'] || 'development'
end

# Run this AFTER you've configured
ActiveRecordTasks.load_tasks

ActiveRecordTasks.configure do |config|
  if config.env == 'production'
    Rake::Task["db:load_config"].invoke
    production_config = ActiveRecord::Tasks::DatabaseTasks.database_configuration['production']
    production_config['hostname'] = ENV['DB_HOST']
    production_config['username'] = ENV['DB_USER']
    production_config['password'] = ENV['DB_PASSWORD']
    production_config['database'] = ENV['TOL_DB']
  end
end

puts ActiveRecord::Tasks::DatabaseTasks.database_configuration

namespace :setup do
  task :seed_database do
    TreeOfLife.getStart
    puts 'Tree of Life Database seeded'
    puts TreeOfLife.db.get_species_by_id(77466)
  end
end
