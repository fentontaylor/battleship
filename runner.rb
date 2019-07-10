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


    add_custom = 'y'
    until add_custom == 'n'
      puts "\nCurrent fleet:"
      puts game.player.ship_info
      print "Would you like to add an extra custom ship? Y / N: "
      add_custom = gets.chomp.downcase
      if add_custom == 'y'
        print "Give your custom ship a name: "
        custom_name = gets.chomp

        valid_length = false
        until valid_length
          print "Choose a length for #{custom_name}: "
          custom_length = gets.chomp.to_i
          if custom_length > size || custom_length < 0
            puts "That is not a valid length."
          else
            valid_length = true
          end
        end
        game.player.ships[custom_name.downcase.to_sym] = Ship.new(custom_name, custom_length)
        game.cpu.ships[custom_name.downcase.to_sym] = Ship.new(custom_name, custom_length)
      end
    end

    game.play_game
  else
    puts "\nOkay, buhbye!"
  end
end
