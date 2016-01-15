require_relative '../weapon'

class PowerHand < Weapon
  def initialize
    @name = "Power Hand"
    @power = 20
    @description = "Use that power hand to kick more asses."
    super
  end
end
