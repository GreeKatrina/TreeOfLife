require 'active_record'

module TreeOfLife
  ActiveSupport::Inflector.inflections(:en) do |inflect|
    inflect.uncountable 'species'
  end
  class ActiveRecordDatabase
    def initialize
      environment = ENV['RACK_ENV'] || 'development'
      if environment == 'development'
        ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
      else
        ActiveRecord::Base.establish_connection(
          :adapter => 'postgresql',
          :database => 'TreeOfLife_dev'
        )
      end
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
