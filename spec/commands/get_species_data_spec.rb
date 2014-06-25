require 'spec_helper.rb'

describe TreeOfLife::GetSpeciesData do
  let(:db) {TreeOfLife.db}
  before(:each) do
    db.clear_table
    db.create_species(species_id: 1, name: "Life on Earth", extinct: false, phylesis: 2, leaf: true, parent_id: 0)
    db.create_species(species_id: 2, name: "Animal", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    db.create_species(species_id: 3, name: "Plant", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    db.create_species(species_id: 4, name: "Bacteria", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    @get_species = TreeOfLife::GetSpeciesData.new
  end

  it 'returns success? is false if the passed in name is not an actual species' do
    result = @get_species.run('test')
    expect(result[:success?]).to eq(false)
  end

  it 'returns success is true if the passed in name is a species' do
    result = @get_species.run('Life on Earth')
    expect(result[:success?]).to eq(true)
  end

  it 'returns a hash with an attribute of species that points to a nested hash containing the species attributes, including children which contains an array of hashes' do
    result = @get_species.run('Life on Earth')
    returned = result[:species]
    expect(returned).to be_a(Hash)
    expect(returned[:species_id]).to eq(1)
    expect(returned[:name]).to eq('Life on Earth')
    expect(returned[:extinct]).to be(false)
    expect(returned[:phylesis]).to eq(2)
    expect(returned[:leaf]).to eq(true)
    expect(returned[:parent_id]).to eq(0)
    expect(returned[:children].count).to eq(3)
    expect(returned[:children][0].class).to eq(Hash)
  end
end
