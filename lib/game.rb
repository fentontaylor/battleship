require './lib/cell'
require './lib/ship'
require './lib/board'
require "pry"

class Game
  attr_reader :cp_board, :pl_board, :cp_ships, :pl_ships


  def initialize
    @cp_board = Board.new
    @pl_board = Board.new
    @cp_ships = {cruiser: Ship.new('Cruiser', 3), submarine: Ship.new('Submarine', 2)}
    @pl_ships = {cruiser: Ship.new('Cruiser', 3), submarine: Ship.new('Submarine', 2)}

  end

  def play_game

    print "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit. --> "
    selection = gets.chomp

    if selection.downcase == 'p'
      puts "\n\n You are now playing BATTLESHIP\n\n" +
      "I have laid out my ships on the grid.\n" +
      "You now need to lay out your two ships.\n" +
      "The Cruiser is three units long and the Submarine is two units long.\n" +
      "#{@pl_board.render}"

      print "Enter the squares for the Cruiser (3 spaces):\n> "
      cruiser_coords = gets.chomp.upcase.split(" ")

      until  @pl_board.valid_placement?(@pl_ships[:cruiser], cruiser_coords)
        print "Those are invalid coordinates. Please try again:\n> "
        cruiser_coords = gets.chomp.upcase.split(" ")
      end

      @pl_board.place(@pl_ships[:cruiser], cruiser_coords)
      puts "#{@pl_board.render(true)}"

      print "Enter the squares for the Submarine (2 spaces):\n> "
      sub_coords = gets.chomp.upcase.split(" ")

      until  @pl_board.valid_placement?(@pl_ships[:submarine], sub_coords)
        print "Those are invalid coordinates. Please try again:\n> "
        sub_coords = gets.chomp.upcase.split(" ")
      end

      @pl_board.place(@pl_ships[:submarine], sub_coords)
      puts "#{@pl_board.render(true)}"

    end

  end
end

game = Game.new
game.play_game
