require 'active_record'
require 'yaml'
require 'pry'

module TreeOfLife
  ActiveSupport::Inflector.inflections(:en) do |inflect|
    inflect.uncountable 'species'
  end
  class ActiveRecordDatabase
    def initialize

      # Figure out what kind of environment to run in - dev is the default
      ENV['APP_ENV'] ||= (ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development')

      # Grab config data from the config file
      db_config = YAML.load_file(File.expand_path('../../../db/config.yml', __FILE__))

      ActiveRecord::Base.establish_connection(
        :adapter  => db_config[ENV['APP_ENV']]['adapter'],
        :database => db_config[ENV['APP_ENV']]['database']
      )
    end

    class Species < ActiveRecord::Base
    end

    def clear_table
      Species.delete_all
    end

    def build_species(species, children=[])
      TreeOfLife::Species.new(species.species_id, species.parent_id, species.name, species.phylesis, species.extinct, species.leaf, children)
    end

    def create_species(attrs)
      ar_species = Species.create!(attrs)
      build_species(ar_species) unless ar_species.nil?
    end

    def get_species_by_id(species_id)
      ar_species = Species.find_by(:species_id => species_id)
      build_species(ar_species) unless ar_species.nil?
    end

    def get_species_by_name(name)
      ar_species = Species.find_by(:name => name)
      build_species(ar_species) unless ar_species.nil?
    end

    def get_species_children(species_id)
      result = Species.where('parent_id = ?', species_id)
      result.map {|child| build_species(child)}
    end
  end
end
