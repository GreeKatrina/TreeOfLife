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
      ar_species != nil ? build_species(ar_species) : nil
    end

    def get_species_by_id(species_id)
      ar_species = Species.where("species_id = ?", species_id).first
      ar_species != nil ? build_species(ar_species) : nil
    end

    def get_species_by_name(name)
      ar_species = Species.where("name = ?", name).first
      ar_species != nil ? build_species(ar_species) : nil
    end

    def get_species_children(name)
      ar_species = Species.where("name = ?", name).first
      return ar_species if ar_species == nil

      result = Species.where('parent_id = ?', ar_species.species_id)
      result.map {|child| build_species(child)}
    end
  end
end
