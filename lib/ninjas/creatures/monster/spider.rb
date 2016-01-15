require_relative '../monster'

class Spider < Monster
  def initialize
    @max_health = 1000
    super
  end
end