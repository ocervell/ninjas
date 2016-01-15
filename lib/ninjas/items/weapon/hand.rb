require_relative '../weapon'

class Hand < Weapon
  def initialize
    @name = "Hand"
    @power = 10
    @description = "Nothing better than a bare fist to kick asses."
    super
  end
end