class AddParentIdColumnToSpeciesTable < ActiveRecord::Migration
  def up
    add_column :species, :parent_id, :integer
  end
end
