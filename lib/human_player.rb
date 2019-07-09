class HumanPlayer

  def initialize(size = 4)
    @size = size
    @board = Board.new(size)
    @ships = {
      cruiser: Ship.new('Cruiser', 3),
      submarine: Ship.new('Submarine', 2)
    }
    @available_shots = @board.cells.keys
    @shots_taken = []
  end

  def ship_info
    @ships.each do |ship, attr|
      name = @ships[ship].name
      length = @ships[ship].length
      puts "- The #{name} is #{length} units long.\n"
    end
  end

  def place_player_ships
    player_ship_info

    puts "#{@board.render}"

    @ships.each do |ship, attr|
      name = @ships[ship].name
      length = @ships[ship].length
      print "Enter the squares for the #{name} (#{length} spaces):\n> "
      ship_coords_string = gets.chomp.upcase
      ship_coords = ship_coords_string.split(" ")

      until  @board.valid_placement?(@ships[ship], ship_coords)
        print "Those are invalid coordinates. Please try again:\n> "
        ship_coords_string = gets.chomp.upcase
        ship_coords = ship_coords_string.split(" ")
      end

      @board.place(@ships[ship], ship_coords)
      puts "#{@board.render(true)}"
    end
  end

  def take_shot
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

end
