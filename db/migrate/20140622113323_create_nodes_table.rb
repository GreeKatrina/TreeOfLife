class CreateNodesTable < ActiveRecord::Migration
  create_table :nodes do |t|
    t.string :name
    t.integer :node_id
    t.boolean :extinct
    t.integer :num_children
    t.boolean :leaf
    t.integer :phylesis
    t.integer :parent_node_id
  end
  add_index :nodes, :node_id
end
