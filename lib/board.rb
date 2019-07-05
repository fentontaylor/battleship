class Board
  attr_reader :cells, :size
  def initialize(size = 4)
    @size = size
    @cells = make_cells
  end

  def make_cells
    rows = ('A'..'Z').to_a[0..@size - 1] * @size
    rows = rows.sort
    cols = (1..@size).to_a * @size
    cell_names = rows.zip cols
    cell_names = cell_names.map(&:join)
    these_cells = {}
    cell_names.each {|cell| these_cells[cell] = Cell.new(cell)}
    these_cells
  end

  def valid_coordinate?(coord)
    @cells.keys.include?(coord)
  end

end
