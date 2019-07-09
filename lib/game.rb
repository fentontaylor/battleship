require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/human_player'
require './lib/computer_player'
require 'colorize'
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
      puts print_game_board

      until all_ships_sunk?(@cpu.ships) || all_ships_sunk?(@player.ships)
        @player.take_shot(@cpu.board)

        unless all_ships_sunk?(@cpu.ships)
          @cpu.take_shot(@player.board)
        end

        print_game_board(true)
      end

      if all_ships_sunk?(@cpu.ships)
        puts "\n \u{1F604} YOU WON! \u{1F604}\n\n"
      else
        puts "\n \u{1F61D} BWAHAHA, I WIN! \u{1F61D}\n"
      end
    end
  end

  def print_game_board(result = false)
    puts "\n\n"
    if result
      puts "=========CP Board=========" +
      "  Shot status: #{report_shot_status(@cpu)}"
    else
      puts "=========CP Board=========\n"
    end
    puts "#{@cpu.board.render}\n"
    if result
      puts "=======Player Board=======" +
      "  Shot status: #{report_shot_status(@player)}"
    else
      puts "=======Player Board=======\n"
    end
    puts "#{@player.board.render(true)}"
  end

  def all_ships_sunk?(ships)
    status = ships.map {|key, ship| ship.sunk?}
    status.all? {|stat| stat == true}
  end

  def report_shot_status(entity)
    last_shot = entity.shots_taken.last
    pronoun = entity.class == HumanPlayer ? "Your" : "My"
    targeted_board = if entity.class == HumanPlayer
        @cpu.board
      else
        @player.board
      end
      targeted_cell = targeted_board.cells[last_shot]
    shot_result = targeted_cell.render
    shot_phrase = if shot_result == "\e[0;39;41mX\e[0m"
        "FATAL BLAST!".colorize(:background => :red)
      elsif shot_result == "\e[0;31;49mH\e[0m"
        "HIT!".colorize(:red)
      else
        "miss...".colorize(:light_blue)
      end
    "#{pronoun} shot on #{last_shot} was a #{shot_phrase}"
    # red H "\e[0;31;49mH\e[0m"
    # light blue M "\e[0;94;49mM\e[0m"
    # Sunk X "\e[0;39;41mX\e[0m"
  end

end
game = Game.new
game.play_game
