require 'spec_helper'

describe TreeOfLife::ActiveRecordDatabase do
  let(:db) {subject}
  before(:each) do
    db.clear_table
    db.create_species(species_id: 1, name: "Tree of Life", extinct: false, phylesis: 2, leaf: true, parent_id: 0)
  end

  it 'creates and gets a species record by id' do
    species = db.get_species_by_id(1)
    expect(species.name).to eq('Tree of Life')
    expect(species.parent_id).to eq(0)
    expect(species.extinct).to eq(false)
    expect(species.phylesis).to eq(2)
    expect(species.leaf).to eq(true)
  end

  it 'gets a species record by name' do
    species = db.get_species_by_name('Tree of Life')
    expect(species.species_id).to eq(1)
    expect(species.parent_id).to eq(0)
    expect(species.extinct).to eq(false)
    expect(species.phylesis).to eq(2)
    expect(species.leaf).to eq(true)
  end

  it "returns a species object with the children attribute pointing to an array of other species objects" do
    db.create_species(species_id: 2, name: "Animal", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    db.create_species(species_id: 3, name: "Plant", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    db.create_species(species_id: 4, name: "Bacteria", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    species = db.get_species_children(1)
    expect(species.class).to eq(TreeOfLife::Species)
    expect(species.children.count).to eq(3)
    expect(species.children[0].class).to eq(TreeOfLife::Species)
    expect(species.children[0]).to_not eq(species.children[1])
    expect(species.children[0]).to_not eq(species.children[2])
  end
end
