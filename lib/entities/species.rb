module TreeOfLife
  class Species
    attr_reader :species_id, :name, :phylesis, :extinct, :leaf, :children, :parent_id
    def initialize(species_id, parent_id, name, phylesis, extinct, leaf, children)
      @species_id = species_id
      @parent_id = parent_id
      @name = name
      @phylesis = phylesis
      @extinct = extinct
      @leaf = leaf
      @children = children
    end
  end
end
