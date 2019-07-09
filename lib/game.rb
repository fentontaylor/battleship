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

  def player_ship_info
    @pl_ships.each do |ship, attr|
      name = @pl_ships[ship].name
      length = @pl_ships[ship].length
      puts "- The #{name} is #{length} units long.\n"
    end
  end

  def place_player_ships
    player_ship_info

    puts "#{@pl_board.render}"

    @pl_ships.each do |ship, attr|
      name = @pl_ships[ship].name
      length = @pl_ships[ship].length
      print "Enter the squares for the #{name} (#{length} spaces):\n> "
      ship_coords_string = gets.chomp.upcase
      ship_coords = ship_coords_string.split(" ")

      until  @pl_board.valid_placement?(@pl_ships[ship], ship_coords)
        print "Those are invalid coordinates. Please try again:\n> "
        ship_coords_string = gets.chomp.upcase
        ship_coords = ship_coords_string.split(" ")
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

      puts "\n\u{26F5} You are now playing BATTLESHIP \u{26F5}\n\n" +
      "I have placed my ships on the grid.\n" +
      "You now need to place your #{@pl_ships.size} ships.\n"

      place_player_ships

      until all_ships_sunk?(@cp_ships) || all_ships_sunk?(@pl_ships)
        print_game_board
        pl_shot

        unless all_ships_sunk?(@cp_ships)
          cp_shot
        end

        print_game_board
      end

      if all_ships_sunk?(@cp_ships)
        puts "\n \u{1F604} YOU WON! \u{1F604}\n\n"
      else
        puts "\n \u{1F61D} BWAHAHA, I WIN! \u{1F61D}\n"
      end
    end
  end

  def print_game_board
    puts "\n" * 2
    puts "=========CP Board=========\n" +
    "#{@cp_board.render}\n"
    puts "=======Player Board=======\n" +
    "#{@pl_board.render(true)}"
  end

  def pl_shot
    print "Enter the coordinate for your shot.\n> "
    shot_coord = gets.chomp.upcase
    shot_coord = shot_coord.strip

    until @pl_available_shots.include?(shot_coord)
      print "Please enter a valid coordinate.\n> "
      shot_coord = gets.chomp.upcase
      shot_coord = shot_coord.strip
    end

    targeted_cell = @cp_board.cells[shot_coord]
    targeted_cell.fire_upon
    @pl_available_shots.delete(shot_coord)
  end

  def cp_shot
    shot_coord = @cp_available_shots.sample
    targeted_cell = @pl_board.cells[shot_coord]
    targeted_cell.fire_upon
    @cp_available_shots.delete(shot_coord)
  end

  def all_ships_sunk?(ships)
    status = ships.map {|key, ship| ship.sunk?}
    status.all? {|stat| stat == true}
  end

end
game = Game.new
game.play_game

# binding.pry
