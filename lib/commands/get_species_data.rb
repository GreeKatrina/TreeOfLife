require 'json'

class TreeOfLife::GetSpeciesData
  def run(species_name)
    returned_species = TreeOfLife.db.get_species_by_name(species_name)
    # binding.pry
    if returned_species
      result_hash = build_entity_hash(returned_species)
      children = TreeOfLife.db.get_species_children(species_name)
      result_hash[:children] = children.map {|child| build_entity_hash(child)}
      return {success?: true,
              species: result_hash
              }
    else
      return {success?: false}
    end
  end

  def build_entity_hash(entity)
    {name: entity.name,
      id: entity.species_id,
      parent_id: entity.parent_id,
      phylesis: entity.phylesis,
      extinct: entity.extinct,
      leaf: entity.leaf,
      data: {}
    }
  end
end
