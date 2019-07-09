require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/human_player'
require './lib/computer_player'
require 'pry'

class Game

  def initialize
    @player = HumanPlayer.new
    @cpu = ComputerPlayer.new
  end

  def play_game
    print "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit. --> "
    selection = gets.chomp

    if selection.downcase == 'p'
      @cpu.place_cp_ships

      puts "\n\u{26F5} You are now playing BATTLESHIP \u{26F5}\n\n" +
      "I have placed my ships on the grid.\n" +
      "You now need to place your #{@player.ships.size} ships.\n"

      @player.place_player_ships

      until all_ships_sunk?(@cpu.ships) || all_ships_sunk?(@player.ships)
        print_game_board
        @player.take_shot(@cpu.board)

        unless all_ships_sunk?(@cpu.ships)
          @cpu.take_shot(@player.board)
        end

        print_game_board
      end

      if all_ships_sunk?(@cpu.ships)
        puts "\n \u{1F604} YOU WON! \u{1F604}\n\n"
      else
        puts "\n \u{1F61D} BWAHAHA, I WIN! \u{1F61D}\n"
      end
    end
  end

  def print_game_board
    puts "\n" * 2
    puts "=========CP Board=========\n" +
    "#{@cpu.board.render}\n"
    puts "=======Player Board=======\n" +
    "#{@player.board.render(true)}"
  end

  def all_ships_sunk?(ships)
    status = ships.map {|key, ship| ship.sunk?}
    status.all? {|stat| stat == true}
  end

end
game = Game.new
game.play_game
