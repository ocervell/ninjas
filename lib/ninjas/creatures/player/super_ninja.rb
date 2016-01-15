require_relative '../player'

class SuperNinja < Ninja
  def initialize(name)
    @max_health = 200
    super(name)
  end

  def taunt
    @gconsole.log "#{@name}: I am a super ninja ! What can you do against me ?"
  end
end