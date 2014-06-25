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
end
