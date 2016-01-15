require_relative '../weapon'

class Knife < Weapon
  def initialize
    @name = "Knife"
    @power = 30
    @description = "A knife between your teeth, you'll become the ultimate warrior."
    super
  end
end