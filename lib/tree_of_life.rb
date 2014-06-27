require 'json'
require 'wikiwhat'

module TreeOfLife
  def self.db
    @__db_instance ||= ActiveRecordDatabase.new
  end
end

require_relative 'data_migration.rb'
require_relative './database/ar_database.rb'
require_relative './entities/species.rb'
require_relative './commands/get_species_data.rb'

