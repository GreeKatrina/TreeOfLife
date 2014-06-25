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

    def build_species(species, children=[])
      TreeOfLife::Species.new(species.species_id, species.parent_id, species.name, species.phylesis, species.extinct, species.leaf, children)
    end

    def create_species(attrs)
      ar_species = Species.create!(attrs)
      build_species(ar_species)
    end

    def get_species_by_id(species_id)
      ar_species = Species.where("species_id = ?", species_id).first
      build_species(ar_species)
    end

    def get_species_by_name(name)
      ar_species = Species.where("name = ?", name).first
      build_species(ar_species)
    end

    def get_species_children(species_id)
      children = []
      ar_species = Species.where("species_id = ?", species_id).first
      result = Species.where('parent_id = ?', species_id)
      result.each do |child|
        children << build_species(child)
      end
      build_species(ar_species, children)
    end
  end
end
