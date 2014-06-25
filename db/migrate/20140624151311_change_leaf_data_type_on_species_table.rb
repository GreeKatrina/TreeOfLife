class ChangeLeafDataTypeOnSpeciesTable < ActiveRecord::Migration
  def up
    remove_column :species, :leaf
  end
end
