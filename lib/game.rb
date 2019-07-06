require './lib/cell'
require './lib/ship'
require './lib/board'
require 'pry'

class Game
  attr_reader :cp_board, :pl_board, :cp_ships, :pl_ships


  def initialize(size = 4)
    @cp_board = Board.new(size)
    @pl_board = Board.new(size)
    @cp_ships = { cruiser: Ship.new('Cruiser', 3),
                  submarine: Ship.new('Submarine', 2)}
    @pl_ships = { cruiser: Ship.new('Cruiser', 3),
                  submarine: Ship.new('Submarine', 2)}
  end

  def place_cp_ships
    rows = @cp_board.row_names
    cols = @cp_board.col_names

    @cp_ships.keys.each do |ship|
      iter_num = @cp_ships[ship].length - 1
      ship_coords = []

      until @cp_board.valid_placement?(@cp_ships[ship], ship_coords)
        ship_coords = []
        cell_seed = rows.sample + cols.sample.to_s
        ship_coords << cell_seed
        orientation = ['horiz', 'vert'].sample

        if orientation == 'horiz'
          iter_num.times { ship_coords << cell_seed[0] + cols.sample.to_s }
          ship_coords = ship_coords.sort

        else
          iter_num.times { ship_coords << rows.sample + cell_seed[1] }
          ship_coords = ship_coords.sort
        end
      end

      @cp_board.place(@cp_ships[ship], ship_coords)
    end
  end

  def play_game
    print "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit. --> "
    selection = gets.chomp

    if selection.downcase == 'p'
      place_cp_ships

      puts "\n\n You are now playing BATTLESHIP\n\n" +
      "I have laid out my ships on the grid.\n" +
      "You now need to lay out your two ships.\n"

      @pl_ships.each do |ship, attr|
        puts "- The #{@pl_ships[ship].name} is #{@pl_ships[ship].length} units long.\n"
      end

      puts "#{@pl_board.render}"

      @pl_ships.each do |ship, attr|
        print "Enter the squares for the #{@pl_ships[ship].name} (#{@pl_ships[ship].length} spaces):\n> "
        ship_coords = gets.chomp.upcase.split(" ")

        until  @pl_board.valid_placement?(@pl_ships[ship], ship_coords)
          print "Those are invalid coordinates. Please try again:\n> "
          ship_coords = gets.chomp.upcase.split(" ")
        end

        @pl_board.place(@pl_ships[ship], ship_coords)
        puts "#{@pl_board.render(true)}"
      end


      puts "==Player Board==\n#{@pl_board.render(true)}"
      puts "====CP Board====\n#{@cp_board.render(true)}"
    end

  end
end

game = Game.new
game.play_game
