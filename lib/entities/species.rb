module TreeOfLife
  class Species
    attr_reader :species_id, :name, :phylesis, :extinct, :leaf
    def initialize(species_id, name, phylesis, extinct, leaf)
      @species_id = species_id
      @name = name
      @phylesis = phylesis
      @extinct = extinct
      @leaf = leaf
    end
  end
end
