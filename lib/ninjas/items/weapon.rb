require_relative '../item'

class Weapon < Item
  attr_reader :power, :health

  def initialize
    @type = 'weapon'
    @cap = 1
    @health = 100
    super
  end

  def use!(source, target)

    #Target is neither a player nor a monster ?
    if target.category != "Player" and target.category != "Monster"
      source.console.log "You cannot use a #{@name} on a #{target.category} !"
      return
    end

    #Weapon is broken ?
    if self.is_broken?
      source.console.log "This weapon is broken. You can't use it now."
      return
    end

    #Target is yourself ?
    if target == source
      source.console.log "You can't hurt yourself !"
      return
    end

    #Target is dead ?
    if target.is_dead?
      source.console.log "This target is dead. Are you really going to hit a dead body ?"
      return
    end

    #Target is not vulnerable to this ?
    if target.cant_take_hit
      source.console.log "You can't hurt #{target.name} right now."
      return
    end

    #If we pass all the above controls, we can actually hit the other player
    source.gconsole.log "#{source.name} hits #{target.name} with #{@name}: -#{@power}"
    target.console.log "You've been hit by #{source.name} ! -#{@power}."
    target.send(:hurt!, @power)

    #Target dead ? Gain XP from his dead body
    if target.is_dead?
      source.console.log "You killed #{target.name} !"
      xp = Calculator.xp_gained(source.level, target.level)
      source.send(:gain_xp, xp)
    end
  end

  def heal!(amount)
    @health += amount
  end

  def increase_power(power)
    @power += power
  end

  def decrease_power(power)
    @power -= power
  end

  def is_broken?
    return @health == 0
  end
end