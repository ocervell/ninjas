require_relative '../player'

class Ninja < Player
  attr_reader :type, :max_health

  def initialize(name)
    @max_health = 100
    super(name)
  end

  def taunt
    @gconsole.log "#{@name}: I am a motherfucking Ninja... Who are you ?"
  end
end