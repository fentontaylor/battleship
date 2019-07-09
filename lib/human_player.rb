class HumanPlayer
  attr_reader :board, :ships
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
    ship_info

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

  def already_fired_at?(shot_coord)
    @shots_taken.include?(shot_coord)
  end

  def take_shot(targeted_board)
    print "Enter the coordinate for your shot.\n> "
    shot_coord = gets.chomp.upcase
    shot_coord = shot_coord.strip

    while already_fired_at?(shot_coord)
      print "You already fired at that coordinate. Pick again.\n> "
      shot_coord = gets.chomp.upcase
      shot_coord = shot_coord.strip
    end

    until @available_shots.include?(shot_coord)
      print "Please enter a valid coordinate.\n> "
      shot_coord = gets.chomp.upcase
      shot_coord = shot_coord.strip
    end

    targeted_cell = targeted_board.cells[shot_coord]
    targeted_cell.fire_upon
    @shots_taken << shot_coord
    @available_shots.delete(shot_coord)
  end

end