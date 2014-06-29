
class TreeOfLife::GetSpeciesData
  def run(species_id)
    returned_species = TreeOfLife.db.get_species_by_id(species_id)
    if returned_species
      result_hash = build_entity_hash(returned_species)
      children = TreeOfLife.db.get_species_children(species_id)
      result_hash[:children] = children.map {|child| build_entity_hash(child)}

      wiki_page = Wikiwhat::Page.new(result_hash[:name], :paragraphs => 1)

      begin
        if wiki_page.paragraphs
          wiki_result = {title: wiki_page.title,
                        paragraphs: wiki_page.paragraphs
                        }
        end
      rescue NoMethodError => e
        wiki_result = false
      end

      begin
        if wiki_page.sidebar_image
          wiki_image = wiki_page.sidebar_image
        end
      rescue
        wiki_image = false
      end

      return {success?: true,
              species: result_hash,
              wiki: wiki_result,
              wiki_sidebar: wiki_image
              }
    else
      return {success?: false}
    end
  end

  def build_entity_hash(entity)
    {name: entity.name,
      id: entity.id,
      parent_id: entity.parent_id,
      phylesis: entity.phylesis,
      extinct: entity.extinct,
      leaf: entity.leaf,
      data: {}
    }
  end
end
