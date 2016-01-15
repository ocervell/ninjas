$LOAD_PATH << './ninjas'
require_relative './test/simulator'

#Color output (works only in native terminals)
Console.colorize

sim = Simulator.new()
# sim.run(number_of_test: 10, args: ['hide_all'])

sim.run(number_of_test: 15, args: ['show_game_console', 'show_player_console'])
# sim.run(number_of_test: 1, args: ['show_game_console'])
# sim.run(number_of_test: 1, args: ['show_game_console', 'show_player_console'])

# ui = UI.new