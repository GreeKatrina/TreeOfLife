require 'json'
require 'pry'

module TreeOfLife
  def self.getStart
    file = File.read('tree_of_life_data.json')
    data_hash = JSON.parse(file, :max_nesting => 500)
    starting_point = data_hash['TREE']['NODES']
    # binding.pry
    database_helper(0, starting_point)
  end

  def self.database_helper(parent_id, tree_hash)
    node_pointer = tree_hash['NODE']
    if node_pointer.class == Hash
      next_parent_id = node_pointer['@ID'].to_i
      # binding.pry
      create_record_helper(parent_id, node_pointer)
      # Recursive call
      if node_pointer['@CHILDCOUNT'] != "0"
        database_helper(next_parent_id, node_pointer['NODES'])
      end
    else
      node_pointer.each do |tree_object|
        database_helper(parent_id, {'NODE' => tree_object})
      end
    end
  end

  def self.create_record_helper(p_id, hash)
    hash.delete('@CONFIDENCE')
    hash.delete('@HASPAGE')
    # convert extinct data to boolean
    hash['@EXTINCT'] == 0 ? extinct = false : extinct = true
     # convert leaf data to boolean
    hash['@LEAF'] == 0 ? leaf = false : leaf = true

    hash['@EXTINCT'] == 0 ? hash['@EXTINCT'] == false : hash['@EXTINCT'] == true
    hash['@LEAF'] == 0 ? hash['@LEAF'] == false : hash['@LEAF'] == true
    TreeOfLife.db.create_species(species_id: hash['@ID'].to_i, name: hash['NAME'], extinct: extinct, phylesis: hash['@PHYLESIS'], leaf: leaf, parent_id: p_id)
  end
end



