class CreateSpeciesTable < ActiveRecord::Migration
  create_table :species do |t|
    t.integer :species_id
    t.string :name
    t.boolean :extinct
    t.integer :phylesis
    t.integer :leaf
  end
  add_index :species, :name
  add_index :species, :species_id
end
