class AddLeafBooleanDataTypeOnSpeciesTable < ActiveRecord::Migration
  def up
    add_column :species, :leaf, :boolean
  end
end
