require 'spec_helper.rb'

describe TreeOfLife::GetSpeciesData do
  let(:db) {TreeOfLife.db}
  before(:each) do
    db.clear_table
    db.create_species(species_id: 1, name: "Life on Earth", extinct: false, phylesis: 2, leaf: true, parent_id: 0)
    db.create_species(species_id: 2, name: "Animal", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    db.create_species(species_id: 3, name: "Plant", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    db.create_species(species_id: 4, name: "Bacteria", extinct: false, phylesis: 2, leaf: true, parent_id: 1)
    db.create_species(species_id: 5, name: "Testing", extinct: false, phylesis: 2, leaf: true, parent_id: 4)
    @get_species = TreeOfLife::GetSpeciesData.new
  end

  describe 'database query for species' do
    it 'returns success? is false if the passed in id is not an actual species' do
      result = @get_species.run(10)
      expect(result[:success?]).to eq(false)
    end

    it 'returns success is true if the passed in name is a species' do
      result = @get_species.run(1)
      expect(result[:success?]).to eq(true)
    end

    it 'returns a hash with an attribute of species that points to a nested hash containing the species attributes, including children which contains an array of hashes' do
      result = @get_species.run(1)
      returned = result[:species]
      expect(returned).to be_a(Hash)
      expect(returned[:id]).to eq(1)
      expect(returned[:name]).to eq('Life on Earth')
      expect(returned[:extinct]).to be(false)
      expect(returned[:phylesis]).to eq(2)
      expect(returned[:leaf]).to eq(true)
      expect(returned[:parent_id]).to eq(0)
      expect(returned[:children].count).to eq(3)
      expect(returned[:children][0].class).to eq(Hash)
    end
  end

  describe 'wikiwhat call' do
    describe 'successful call' do
      it 'returns a key of wiki pointing to the species wikipedia info, including the title, 1st paragraph and sidebar img' do
        result = @get_species.run(1)
        expect(result[:species][:name]).to eq('Life on Earth')
        expect(result[:wiki].paragraphs.size).to eq(1)
      end
    end

    describe 'unsuccessful call' do
      it 'returns a key of wiki pointing to false' do
        db.create_species(species_id: 10, name: "Carboxydothermus", extinct: false, phylesis: 2, leaf: true, parent_id: 4)
        result = @get_species.run(10)
        expect(result[:species][:name]).to eq("Carboxydothermus")
        expect(result[:wiki]).to eq(false)
      end
    end

    describe 'getting sidebar image' do
      it "gets the sidebar image for a page and returns the url in the wiki_sidebar attribute" do
        result = @get_species.run(2)
        expect(result[:wiki_sidebar]).to eq(result[:wiki].sidebar_image)
      end
    end

      it "returns false for the sidebar image for a page in the wiki_sidebar attribute" do
        result1 = @get_species.run(1)
        expect(result1[:wiki_sidebar]).to eq(false)
      end
  end
end
