class Game
  @@max_players = 5
  @@max_monsters = 100

  attr_accessor :console
  attr_reader :max_players, :max_monsters, :players, :monsters

  def initialize(max_players=@@max_players, max_monsters=@@max_monsters)
    @console = Console.new
    @max_players = max_players
    @max_monsters = max_monsters
    check_capacity
    @players = []
    @monsters = []
    @start_time = Time.now
  end

  public

  def status
    @duration = sprintf("%0.02f", (Time.now - @start_time) % 60)
    @console.log "============ GAME ============"
    @console.log("Maximum: Players -> #{@max_players}, Monsters -> #{@max_monsters}")
    @console.log "Number of players: #{@players.length}"
    @console.log "Number of monsters: #{@monsters.length}"
    @console.log "Players: " if @players != []
    @players.each do |player|
      @console.log( "\t" + player.name + ' (' + player.type + ') - Level ' + player.level.to_s + ' - Life: ' + player.health.to_s + '/' + player.max_health.to_s)
    end
    @console.log("Monsters: ") if @monsters != []
    @monsters.each do |monster|
      @console.log( "\t" + monster.type +
                    " - Level " + monster.level.to_s
                  )
    end
    @console.log("==============================")
  end

  def update
    @players.each do |p|
      remove_player(p) if p.is_dead?
    end
    @monsters.each do |m|
      remove_monster(m) if m.is_dead?
    end
  end

  def add(creature)
    case creature.category
    when "Monster"
      add_monster(creature)
    when "Player"
      add_player(creature)
    else
      raise "Unknown category #{creature.category}"
    end
  end

  def remove(creature)
    case creature.category
    when "Monster"
      remove_monster(creature)
    when "Player"
      remove_player(creature)
    else
      raise "Unknown category #{creature.category}"
    end
  end

  def add_player(player)

    #max game capacity reached: do nothing
    if @players.length == @capacity
      @console.log_error "Maximum number of players (#{@max_players}) reached. \
                          Couldn't add #{player.name} to the game."
      return
    end

    #existing player: do nothing
    if @players.any?{|p| p.name == player.name}
      @console.log_error "Player #{player.name} already exists."
      return
    end

    #player doesn't exist and max game capacity is not reached
    @players.push(player)
    @console.log "#{player.name} the #{player.type} joined the game."
  end

  def remove_player(player)
    if @players.delete(player)
      @console.log "#{player.name} is out of the game."
    end
  end

  def add_monster(monster)
    #max game capacity reached: do nothing
    if @monsters.length == @capacity
      @console.log_error "Maximum number of monsters (#{@max_monsters}) reached.
                          Couldn't add #{monster.name} to the game."
      return
    end
    @monsters.push(monster)
    @console.log "#{monster.type} joined the game."
  end

  def remove_monster(monster)
    if @monsters.delete(monster)
      @console.log "#{monster.name} is out of the game."
    end
  end

  def clear_game
    @players.each do |player|
      remove_player(player)
    end
  end

  private

  def check_capacity
    if @max_players > @@max_players
      raise "Player capacity higher than max player capacity (#{@@max_players}"
    end
    if @max_monsters > @@max_monsters
      raise "Monster capacity higher than max monster capacity (#{@@max_monsters}"
    end
  end
end

