require 'require_all'
require_all 'ninjas'

class Simulator

  @@player_names   = ["Brett", "Shade", "Josh", "Garett", "Jack", "Robb", "Tasha"]
  @@player_types   = ["Ninja",
                      "SuperNinja",
                      "MegaNinja"
                     ]
  @@monster_types  = ["Spider", "BigSpider"]
  @@weapon_types   = ["Hand",
                      "PowerHand",
                      "Knife",
                      "Blade"]
  @@heal_types     = ["SmallPotion", "BigPotion"]
  @@tool_types     = ["Key"]
  @@goals          = ['generate_game',
                      'generate_players',
                      'generate_players_inventory',
                      'generate_monsters',
                      'add_players_to_game',
                      'add_monsters_to_game',
                      'fight_monsters',
                      'fight_players',
                      'remove_players_from_game',
                      'remove_game'
                     ]
  @@phases         = { :generate => ['generate_game', 'generate_players', 'generate_players_inventory', 'generate_monsters'],
                       :populate => ['add_players_to_game', 'add_monsters_to_game'],
                       :fight    => ['fight_players', 'fight_monsters'],
                       :remove   => ['remove_players_from_game', 'remove_monsters_from_game', 'remove_game']
                     }
  attr_reader :console
  $seed = 50

  def initialize
    @players = []
    @monsters = []
    @console = Console.new('sim')
    @phases = []
  end

  ####################
  ## RUN SIMULATION ##
  ####################
  public

  def run(number_of_test: 1, phases: [], goals: [], args: [])
    parse_options(args)
    parse_phases(phases)
    parse_goals(goals)
    print_phases
    @console.log_sim("Launching simulation with #{number_of_test} tests...\n\n")
    number_of_test.times{ |i|
      @console.log("=========== PASS #{i+1}/#{number_of_test} ===========\n\n")
      @phases.each do |phase|
        phase.execute
      end
    }
  end

  ############
  ## PHASES ##
  ############
  class Phase
    attr_reader :name, :goals
    attr_accessor :console, :simulator
    def initialize(name, goals)
      @name = name
      @goals = goals
      @simulator = nil
      @console = nil
    end
    def execute
      @console.log_sim("PHASE: #{name}...")
      @goals.each do |goal|
        begin
          @console.log_sim("\tGOAL: #{goal}...")
          @simulator.send(goal)
        rescue => e
            @console.log_sim("\tGOAL: #{goal} => FAILED\n\n")
            @console.log_sim("#{name} => FAILED")
            raise e
        end
        @console.log_sim("\tGOAL: #{goal} => SUCCESS")
      end
      @console.log_sim("PHASE: #{name} ==> SUCCESS\n\n")
    end
  end

  def create_phase(name, goals)
    phase = Phase.new(name, goals)
    phase.console = @console
    phase.simulator = self
    @phases.push(phase)
  end

  def parse_phases(phases)
    if phases == []
      @@phases.each do |name, goals|
        create_phase(name.to_s, goals)
      end
    end
    phases.each do |name|
      if not @@phases.has_key? name.intern
        @console.log_error("Phase #{name} is not a valid phase.")
        raise "Invalid phase."
      end
      create_phase(name, goals)
    end
  end

  def print_phases
    @console.log_sim("Phases:")
    @phases.each do |phase|
      @console.log_sim(phase.name)
      phase.goals do |goal|
        @console.log_sim(goal)
      end
    end
  end

  def parse_goals(goals)
    return if goals == []
    begin
      goals.each do |goal|
        if not @@goals.include? goal
          @console.log_error("Goal #{goal} is not a valid goal.")
          raise "Invalid goal."
        end
      end
    rescue => e
      @console.log_error("An error occured while parsing goal #{goal}.")
      raise e
    end
    create_phase('standard', goals)
  end

  ###################
  # PHASE : GENERATE
  ###################
  public

  def generate_game
    #Generate a game with random capacity between 2 and 10 players
    pcap = Random.new.rand(2..5)
    mcap = Random.new.rand(2..50)
    @game = Game.new(max_players = pcap, max_monsters = mcap)
    @game.console.show = false if !@disp_g
    @console.log_sim("Game status:") if @disp_g
    @game.status
  end

  def generate_players
    return if @players.length == @game.max_players
    n = Random.new.rand(2..@game.max_players)
    n.times {
      player = generate_random_player
      player.console.show = false if !@disp_p
      @players.push(player)
    }
    @console.log_sim("Game status:") if @disp_g
    @game.status
  end

  def generate_players_inventory
    @players.each do |player|
      n = Random.new.rand(2..player.inventory.max_items)
      n.times {
        weapon = generate_random_item('weapon')
        heal = generate_random_item('heal')
        tool = generate_random_item('tool')
        player.inventory.add_items([weapon, heal, tool])
      }
      player.inventory.status
    end
  end

  def generate_monsters
    return if @monsters.length == @game.max_monsters
    n = Random.new.rand(2..@game.max_monsters)
    n.times {
      monster = generate_random_monster
      @monsters.push(monster)
    }
    @console.log_sim("Game status:") if @disp_g
    @game.status
  end

  #####################
  # PHASE : POPULATE #
  #####################
  public

  def add_players_to_game
    raise "No players to add !" if @players == []
    @players.each do |player|
      player.join_game(@game)
    end
    @console.log_sim("Game status:") if @disp_g
    @game.status
  end

  def add_monsters_to_game
    @monsters.each do |monster|
      monster.join_game(@game)
    end
    @console.log_sim("Game status:") if @disp_g
    @game.status
  end

  ##################
  # PHASE : FIGHT #
  ##################
  public

  def fight_players
    $seed.times{
      ninja = random_player_from_game
      target = random_player_from_game
      weapon = random_item_from_inventory("weapon", ninja.inventory)
      # ninja.use!(target, weapon)
      @game.update
    }
    @console.log_sim("Game status:") if @disp_g
    @game.status
  end

  def fight_monsters
    until @game.monsters.length == 0 do
      ninja = random_player_from_game
      target = random_monster_from_game
      weapon = random_item_from_inventory("weapon", ninja.inventory)
      ninja.use!(target, weapon)
      @game.update
    end
    @console.log_sim("Game status:") if @disp_g
    @game.status
  end

  #############################
  # PHASE : REMOVE FROM GAME #
  #############################
  public

  def remove_game
    remove_instance_variable(:@game)
  end

  def remove_players_from_game
    @players.each do |player|
      player.quit_game(@game)
    end
    @players = []
    @console.log_sim("Game status:") if @disp_g
    @game.status
  end

  def remove_monsters_from_game
    @monsters.each do |monster|
      monster.quit_game(@game)
    end
    monsters = []
    @console.log_sim("Game status:") if @disp_g
  end

  ###########
  # HELPERS #
  ###########
  private

  def parse_options(args)
    if args.empty?
      @disp_p = false
      @disp_g = false
      return
    end
    args.each do |arg|
      case arg
      when 'show_player_console'
        @disp_p = true
      when 'show_game_console'
        @disp_g = true
      when 'show_all'
        @disp_g = true
        @disp_p = true
      when 'hide_all'
        @disp_g = false
        @disp_p = false
        @console.show = false
      when 'debug'
        @disp_g = false
        @disp_p = false
        @console.show = false
      end
    end
  end

  def generate_random_player
    name = @@player_names.sample
    type = @@player_types.sample
    random_player = Object.const_get(type) #get specific ninja class
    return random_player.new(name) #create new ninja, superninja, ...
  end

  def generate_random_monster
    monster_type = @@monster_types.sample
    random_monster = Object.const_get(monster_type)
    return random_monster.new
  end

  def generate_random_item(type)
    item_type = eval("@@" + type + "_types").sample #Get @@heal_types.sample, @@weapon_types.sample ...
    random_item = Object.const_get(item_type)
    return random_item.new
  end

  def random_player_from_game
    return @game.players.sample
  end

  def random_monster_from_game
    return @game.monsters.sample
  end

  def random_item_from_inventory(type, inventory)
    item = inventory.items.select{|item| item.type == type}
    return item.sample
  end

end
