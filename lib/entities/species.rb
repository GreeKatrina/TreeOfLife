module TreeOfLife
  class Species
    attr_reader :id, :name, :phylesis, :extinct, :leaf, :children, :parent_id
    def initialize(id, parent_id, name, phylesis, extinct, leaf, children)
      @id = id
      @parent_id = parent_id
      @name = name
      @phylesis = phylesis
      @extinct = extinct
      @leaf = leaf
      @children = children
    end
  end
end
