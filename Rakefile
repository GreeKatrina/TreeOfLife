require 'active_record_tasks'
require './lib/tree_of_life.rb'

ActiveRecordTasks.configure do |config|
  # These are all the default values
  config.db_dir = 'db'
  config.db_config_path = 'db/config.yml'
  config.env = 'test'
end

# Run this AFTER you've configured
ActiveRecordTasks.load_tasks


namespace :setup do
  task :seed_database do
    TreeOfLife.getStart
    puts 'Tree of Life Database seeded'
    puts TreeOfLife.db.get_species_by_id(77466)
  end
end
