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
    valid_size = false
    until valid_size
      print "Enter board side length (4-12): "
      size = gets.chomp.to_i
      if size < 4 || size > 12
        puts "That is not a valid size."
      else
        valid_size = true
      end
    end
    game = Game.new(size)
    game.player.ships[:jungus] = Ship.new("Jungus", 5)
    game.play_game
  else
    puts "\nOkay, buhbye!"
  end
end
