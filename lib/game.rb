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
    @pl_available_shots = @cp_board.cells.keys
    @cp_available_shots = @pl_board.cells.keys
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
          change = [1, -1].sample
          iter_num.times do
            new_col = cell_seed[/[\d]+/].to_i + change
            ship_coords << cell_seed[0] + new_col.to_s
          end
          ship_coords = ship_coords.sort

        else
          unless cell_seed[0] == 'A'
            change = [1, -1].sample
          else
            change = 1
          end

          iter_num.times do
            new_row = (cell_seed[0].ord + change).chr
            ship_coords << rows.sample + cell_seed[/[\d]+/].to_s
          end
          ship_coords = ship_coords.sort
        end
      end

      @cp_board.place(@cp_ships[ship], ship_coords)
    end
  end

  def place_player_ships
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

  end

  def play_game
    print "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit. --> "
    selection = gets.chomp

    if selection.downcase == 'p'
      place_cp_ships

      puts "\n\n*** You are now playing BATTLESHIP ***\n\n" +
      "I have placed my ships on the grid.\n" +
      "You now need to place your #{@pl_ships.size} ships.\n"

      place_player_ships

      until all_ships_sunk?(@cp_ships) || all_ships_sunk?(@pl_ships)

        puts "\n" * 2
        puts "====CP Board====\n#{@cp_board.render}\n"
        puts "==Player Board==\n#{@pl_board.render(true)}"
        pl_shot
        cp_shot 

      end
    end

  end

  def pl_shot
    print "Enter the coordinate for your shot.\n> "
    shot_taken = gets.chomp.upcase
    shot_taken = shot_taken.strip

    until @pl_available_shots.include?(shot_taken)
      print "Please enter a vailid coordinate.\n> "
      shot_taken = gets.chomp.upcase
      shot_taken = shot_taken.strip
    end

    targeted_cell = @cp_board.cells[shot_taken]
    targeted_cell.fire_upon
    @pl_available_shots.delete(shot_taken)
  end

  def cp_shot
    shot_taken = @cp_available_shots.sample
    targeted_cell = @pl_board.cells[shot_taken]
    targeted_cell.fire_upon
    @cp_available_shots.delete(shot_taken)
  end

  def all_ships_sunk?(ships)
    status = ships.map {|key, ship| ship.sunk?}
    status.all? {|stat| stat == true}
  end

end
game = Game.new
game.play_game

binding.pry
