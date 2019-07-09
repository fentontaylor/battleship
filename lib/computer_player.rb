class ComputerPlayer
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

  def place_cp_ships
    rows = @board.row_names
    cols = @board.col_names

    @ships.keys.each do |ship|
      iter_num = @ships[ship].length - 1
      ship_coords = []

      until @board.valid_placement?(@ships[ship], ship_coords)
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

      @board.place(@ships[ship], ship_coords)
    end
  end

  def take_shot(targeted_board)
    shot_coord = @available_shots.sample
    targeted_cell = targeted_board.cells[shot_coord]
    targeted_cell.fire_upon
    @shots_taken << shot_coord
    @available_shots.delete(shot_coord)
  end
end
