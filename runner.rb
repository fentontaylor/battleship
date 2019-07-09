require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'
require './lib/human_player'
require './lib/computer_player'
require 'colorize'

selection = 'p'
until selection == 'q'
  print "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit. --> "
  selection = gets.chomp.downcase

  if selection == 'p'
    game = Game.new
    game.play_game
  else
    puts "\nOkay, buhbye!"
  end
end
