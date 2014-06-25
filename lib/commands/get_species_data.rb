require 'json'

class TreeOfLife::GetSpeciesData
  def run(species_name)
    returned_species = TreeOfLife.db.get_species_by_name(species_name)
    if returned_species
      result_hash = build_entity_hash(returned_species)
      # children =
      # return {success?: true,
      #         species:
      #         }
    else
      return {success?: false}
    end
  end

  def build_entity_hash(entity)
    {name: entity.name,
      species_id: entity.name,
      parent_id: entity.species_id,
      phylesis: entity.phylesis,
      extinct: entity.extinct,
      leaf: entity.leaf
    }
  end
end
