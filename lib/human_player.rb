class HumanPlayer
  attr_reader :board, :ships, :shots_taken
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
    info = @ships.map do |ship, attr|
      name = @ships[ship].name
      length = @ships[ship].length
      "- The #{name} is #{length} units long.\n"
    end
    info.join
  end

  def place_player_ships
    puts ship_info

    puts "#{@board.render}"

    @ships.each do |ship, attr|
      name = @ships[ship].name
      length = @ships[ship].length

      ready_to_place = false
      until ready_to_place
        print "Enter the squares for the #{name} (#{length} spaces):\n> "
        ship_coords_string = gets.chomp.upcase
        ship_coords = ship_coords_string.split(" ")

        unless @board.valid_placement?(@ships[ship], ship_coords)
          puts "Those are invalid coordinates. Please try again."
        else
          ready_to_place = true
        end
      end

      @board.place(@ships[ship], ship_coords)
      puts "#{@board.render(true)}"
    end
  end

  def already_fired_at?(shot_coord)
    @shots_taken.include?(shot_coord)
  end

  def take_shot(targeted_board)
    ready_to_fire = false
    until ready_to_fire
      print "Enter the coordinate for your shot.\n> "
      shot_coord = gets.chomp.upcase.strip

      if already_fired_at?(shot_coord)
        puts "You already fired at that coordinate."
      elsif !@available_shots.include?(shot_coord)
        puts "That is not a valid coordinate."
      else
        ready_to_fire = true
      end
    end

    targeted_cell = targeted_board.cells[shot_coord]
    targeted_cell.fire_upon
    @shots_taken << shot_coord
    @available_shots.delete(shot_coord)
  end
end
