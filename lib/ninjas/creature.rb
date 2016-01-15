require 'inventory'
require 'calculator'

class Creature
  attr_reader :name, :type, :category, :health, :xp_required, :xp_total, :xp, :level
  attr_reader :inventory
  attr_reader :category
  attr_reader :console, :gconsole
  include Calculator

  def initialize(name='')
    @type = self.class.to_s
    @name = name
    @name = @type if name == '' #monsters don't have name
    @level = 1
    @xp = 0
    @xp_total = 0
    @xp_required = Calculator.xp_required(@level)
    @health = @max_health
    @inventory = Inventory.new(self)
    generate_console
  end

  ################
  # META ACTIONS #
  ################

  public

  def join_game(game)
    @gconsole = game.console
    game.add(self)
  end

  def quit_game(game)
    game.remove(self)
  end

  def write_to_console(game, msg)
    game.console.log(@name + ": " + msg)
  end

  def generate_console
    @console = Console.new(name=@name)
    @console.record = false if @category == "Monster"
  end

  def use!(target, item)
    item.use!(self, target)
  end

  #########
  # FIGHT #
  #########

  public

  def is_dead?
    @health <= 0
  end

  def cant_take_heal
    @health == @max_health
    #OTHER THINGS HERE LIKE INCAPACITATED, ETC
  end

  def cant_take_hit
    false
  end

  private

  def heal!(amount)
    @health += amount
    @health = [@health, @max_health].min
  end

  def hurt!(amount)
    @health -= amount
    @health = 0 if @health <= 0
    @console.log "Life: #{@health}/#{@max_health}"
    die if is_dead?
  end

  def die
    @console.log "You die !"
    @gconsole.log "#{@name} is dead."
    @health = 0
  end

  ######
  # XP #
  ######

  private

  def gain_xp(amount)
    @xp += amount
    @xp_total += amount
    @console.log "You gained #{amount} XP."
    level_up?
  end

  def level_up?
    return if not @xp >= @xp_required
    @xp = @xp - @xp_required
    @level += 1
    @max_health += 100
    @health = @max_health*75/100
    @xp_required = Calculator.xp_required(@level)
    @console.log "Level up ! You're now on level #{@level}. XP required to level up: #{@xp_required}"
    @gconsole.log "#{@name} is now on level #{@level}."
  end
end