class Item
  attr_reader :type, :name, :description, :cap

  def initialize
    verify_item
  end

  def verify_item
    if not self.respond_to?(:type)
      raise "Item #{self.to_s} does not have a type"
    end
    if not self.respond_to?(:name)
      raise "Item #{self.to_s} does not have a name"
    end
    if not self.respond_to?(:description)
      puts "WARNING: Item doesn't have a description"
    end
    if not self.respond_to?(:cap)
      puts "WARNING: Item doesn't have a max capacity"
    end
  end
end


########
# TOOL #
########
class Tool < Item
  def initialize
    @type = "tool"
    @cap = 1
    super
  end
end

class Key < Tool
  def initialize
    @name = "Key"
    @description = "A simple key to lock and unlock doors."
    super
  end
end