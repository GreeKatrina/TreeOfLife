require 'active_record'
require 'pry'

module TreeOfLife
  ActiveSupport::Inflector.inflections(:en) do |inflect|
    inflect.uncountable 'species'
  end
  class ActiveRecordDatabase
    def initialize
      ActiveRecord::Base.establish_connection(
      :adapter => 'postgresql',
      :database => 'TreeOfLife_test'
      )
    end

    class Species < ActiveRecord::Base
    end

    def clear_table
      Species.delete_all
    end

    def build_species(species)
      TreeOfLife::Species.new(species.species_id, species.name, species.phylesis, species.extinct, species.leaf)
    end

    def create_species(attrs)
      Species.create!(attrs)
    end

    def get_species_by_id(species_id)
      Species.where("species_id = ?", species_id).first
    end

    def get_species_by_name(name)
      Species.where("name = ?", name).first
    end
  end
end
