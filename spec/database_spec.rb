require 'spec_helper'

describe 'TreeOfLife database singleton' do
  it "always returns the same object" do
    database1 = TreeOfLife.db
    database2 = TreeOfLife.db
    # Create some data just in case
    database1.create_species(species_id: 1, name: "Tree of Life", extinct: false, phylesis: 2, leaf: true, parent_id: 0)

    # They should still be equal
    expect(database1).to eq database2
  end

  it "resets for every test" do
    # expect(TreeOfLife.db.all_items.count).to eq 0
  end
end
