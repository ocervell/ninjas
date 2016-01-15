require_relative '../weapon'

class Blade < Weapon
  def initialize
    @name = "Blade"
    @power = 50
    @description = "What better than a blade to kill the bad guys?"
    super
  end
end