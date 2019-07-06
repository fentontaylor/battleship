class Board
  attr_reader :cells, :size
  def initialize(size = 4)
    @size = size
    @row_names = ('A'..'Z').to_a[0..@size - 1]
    @col_names = (1..@size).to_a
    @cells = make_cells
  end

  def make_cells
    rows = @row_names * @size
    rows = rows.sort
    cols =  @col_names * @size
    cell_names = rows.zip cols
    cell_names = cell_names.map(&:join)
    these_cells = {}
    cell_names.each {|cell| these_cells[cell] = Cell.new(cell)}
    these_cells
  end

  def valid_coordinate?(coord)
    @cells.keys.include?(coord)
  end

  def all_valid_coords?(coords_array)
    coords_array.all? {|coord| valid_coordinate?(coord)}
  end

  def valid_length?(ship, coords_array)
    ship.length == coords_array.length
  end

  def consecutive?(coords_array)
    coord_rows = coords_array.map {|coord| coord[0].ord}
    coord_cols = coords_array.map {|coord| coord[1].to_i}

    if coord_rows.uniq.length == 1 # All coords from same row
      diff =  coord_cols.map.with_index do |coord, index|
                unless index == coord_cols.length - 1
                  coord_cols[index + 1] - coord
                end
              end
      diff.pop
      diff.all? {|num| num == 1}

    elsif coord_cols.uniq.length == 1 # All coords from same column
      diff =  coord_rows.map.with_index do |coord, index|
                unless index == coord_rows.length - 1
                  coord_rows[index + 1] - coord
                end
              end
      diff.pop
      diff.all? {|num| num == 1}

    else
      false
    end
  end

  def all_free_spaces?(coords_array)
    coords_array.all? {|coord| @cells[coord].ship.nil?}
  end

  def valid_placement?(ship, coords_array)
    all_checks = [all_valid_coords?(coords_array),
                  valid_length?(ship, coords_array),
                  consecutive?(coords_array),
                  all_free_spaces?(coords_array)]

    all_checks.all? {|check| check == true}
  end

  def place(ship, coords_array)
    coords_array.each do |coord|
      @cells[coord].place_ship(ship)
    end
  end

  def render(show_ship = false)
    cell_names = @cells.keys
    rendered_cells = cell_names.map {|cell| @cells[cell].render(show_ship)}
    output_rows = ["  #{@col_names.join(' ')} \n"]

    (0..@size -1).each do |i|
      these_cells = rendered_cells[(i * @size)..((i + 1) * @size - 1)].join(' ')
      output_rows << "#{@row_names[i]} #{these_cells} \n"
    end

    output_rows.join
  end
end
