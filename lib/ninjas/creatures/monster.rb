require_relative '../creature'

class Monster < Creature
  def initialize
    @category = "Monster"
    super
  end

  def change_level(caller, level)
    if get_classname(caller) == "Game"
      level_up until @level = level
    end
  end
end