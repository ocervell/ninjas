require_relative '../player'

class MegaNinja < Ninja
  attr_reader :type

  def initialize(name)
    @max_health = 500
    super(name)
  end

  def taunt
    @gconsole.log "#{@name}: I am jerking off ! Fuck off."
  end
end