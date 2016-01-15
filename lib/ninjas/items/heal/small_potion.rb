require_relative '../heal'

class SmallPotion < Heal
  def initialize
    @name = "Small Potion"
    @power = 10
    @description = "A small potion !"
    super
  end
end