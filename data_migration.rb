require 'json'

class DataTree
  attr_accessor :head
  def initialize
    file = File.read('tree_of_life_data.json')
    data_hash = JSON.parse(file, :max_nesting => 500)
    @head = create_head(data_hash)
    create_tree(@head, data_hash['TREE']['NODES']["NODE"]['NODES']['NODE'])
  end

  # create head of tree without unnecessary attributes
  def create_head(hash)
    temp_hash = hash['TREE']['NODES']["NODE"].keep_if {|key, value| value.class != Hash}
    temp_hash.delete('@CONFIDENCE')
    temp_hash.delete('@HASPAGE')
    temp_hash.delete('@NODES')
    temp_hash
  end

  def create_tree(parent_node, data_structure)
    data_structure.each do |hash|
      extract_node(parent_node['@ID'], hash)
    end
  end

  def extract_node(parent_id, hash)
    hash.keep_if {|key, value| value.class != Hash}
    hash.delete('@CONFIDENCE')
    hash.delete('@HASPAGE')
    hash.delete('@NODES')
    hash['parent_id'] = parent_id
    hash
  end
end

