require 'active_record_tasks'

task :environment do
  require './lib/tree_of_life.rb'
end

# set :environment, :development, :production

ActiveRecordTasks.configure do |config|
  # These are all the default values
  config.db_dir = 'db'
  config.db_config_path = 'db/config.yml'
  config.env = ENV['RACK_ENV'] || 'development'
end

# # Run this AFTER you've configured
ActiveRecordTasks.load_tasks

# puts ActiveRecord::Tasks::DatabaseTasks.database_configuration

namespace :setup do
  task :seed_database => :environment do
    TreeOfLife.getStart
    puts 'Tree of Life Database seeded'
    puts TreeOfLife.db.get_species_by_id(77466)
  end
end
