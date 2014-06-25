class AddIndexForIdToSpeciesTable < ActiveRecord::Migration
  add_index :species, :parent_id
end
