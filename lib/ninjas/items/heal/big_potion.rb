require_relative '../heal'

class BigPotion < Heal
  def initialize
    @name = "Big Potion"
    @power = 40
    @description = "A big potion !"
    super
  end
end