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

  it 'returns nil if the species does not exist' do
    species = db.get_species_by_name('test')
    expect(species).to eq(nil)
  end

  it 'gets a species record by name' do
    species = db.get_species_by_name('Tree of Life')
    expect(species.id).to eq(1)
    expect(species.parent_id).to eq(0)
    expect(species.extinct).to eq(false)
    expect(species.phylesis).to eq(2)
    expect(species.leaf).to eq(true)
  end

  it 'returns an array of species entities that are the children of the inputted species' do
    db.create_species(species_id: 2, name: "Animal", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    db.create_species(species_id: 3, name: "Plant", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    db.create_species(species_id: 4, name: "Bacteria", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    db.create_species(species_id: 4, name: "Other", extinct: false, phylesis: 2, leaf: true, parent_id: 2)
    species = db.get_species_children(1)
    expect(species.count).to eq(3)
    expect(species[0].class).to eq(TreeOfLife::Species)
    expect(species.map(&:name)).to include("Animal", "Plant", "Bacteria")
  end
end
