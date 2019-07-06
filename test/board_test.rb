require './lib/cell'
require './lib/ship'
require './lib/board'
require 'minitest/autorun'
require 'minitest/pride'

class BoardTest < Minitest::Test

  def setup
    @board = Board.new
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_row_and_col_names
    assert_equal %w[A B C D], @board.row_names
    assert_equal [1, 2, 3, 4], @board.col_names
  end

  def test_default_size_is_4_by_4
    assert_equal 4 * 4, @board.cells.keys.length
  end

  def test_cells_attribute
    assert_instance_of Hash, @board.cells
    assert_equal 16, @board.cells.keys.length
    assert_equal 16, @board.cells.values.length
    assert_instance_of Cell, @board.cells["A1"]
  end

  def test_valid_coordinate?
    assert @board.valid_coordinate?("A1")
    assert @board.valid_coordinate?("D4")
    refute @board.valid_coordinate?("A5")
    refute @board.valid_coordinate?("E1")
    refute @board.valid_coordinate?("A22")
  end

  def test_all_valid_coords?
      refute @board.all_valid_coords?(%w[A3 A4 A5])
      refute @board.all_valid_coords?(%w[C2 D2 E2])
      assert @board.all_valid_coords?(%w[B1 B2 B3])
      assert @board.all_valid_coords?(%w[A3 B3 D3])
      assert @board.all_valid_coords?(%w[A3 B3 D4])
  end

  def test_valid_length?
    cruiser = Ship.new("Cruiser", 3)
    sub = Ship.new("Submarine", 2)

    refute @board.valid_length?(cruiser,%w[B1 B2 B3 B4])
    refute @board.valid_length?(cruiser,%w[B1 B2])
    assert @board.valid_length?(cruiser,%w[B1 B2 B3])

    refute @board.valid_length?(sub,%w[B1 B2 B3 B4])
    refute @board.valid_length?(sub,%w[B1])
    assert @board.valid_length?(sub,%w[B1 B2])
  end

  def test_consecutive_coordinates
    refute @board.consecutive?(%w[A1 A2 A4])
    refute @board.consecutive?(%w[A1 C1])
    refute @board.consecutive?(%w[A3 A2 A1])
    refute @board.consecutive?(%w[A1 B2 C3])
    assert @board.consecutive?(%w[C1 C2 C3])
    assert @board.consecutive?(%w[A1 B1 C1])
  end

  def test_valid_placement?
    cruiser = Ship.new("Cruiser", 3)
    sub = Ship.new("Submarine", 2)

    refute @board.valid_placement?(sub, ["A1", "A3"])
    refute @board.valid_placement?(sub, ["A1", "A2", "A3"])
    assert @board.valid_placement?(sub, ["A1", "A2"])
    assert @board.valid_placement?(sub, ["B3", "C3"])


    refute @board.valid_placement?(cruiser, ["A1", "C1", "D1"])
    refute @board.valid_placement?(cruiser, ["C1", "D1"])
    assert @board.valid_placement?(cruiser, ["B1", "C1", "D1"])
    assert @board.valid_placement?(cruiser, ["B1", "B2", "B3"])
  end

  def test_can_place_ships_on_board
    cruiser = Ship.new("Cruiser", 3)
    @board.place(cruiser, ["A1", "A2", "A3"])
    cell_1 = @board.cells["A1"]
    cell_2 = @board.cells["A2"]
    cell_3 = @board.cells["A3"]

    assert_instance_of Ship, cell_1.ship
    assert_equal cell_2.ship, cell_3.ship
  end

  def test_all_free_spaces?
    assert @board.all_free_spaces?(["A1", "A2", "A3"])

    cruiser = Ship.new("Cruiser", 3)
    @board.place(cruiser, ["A1", "A2", "A3"])

    refute @board.all_free_spaces?(["A1", "A2", "A3"])
    refute @board.all_free_spaces?(["A2", "B2", "C2"])
  end

  def test_cannot_places_ships_in_occupied_cells
    cruiser = Ship.new("Cruiser", 3)
    @board.place(cruiser, ["A1", "A2", "A3"])
    sub = Ship.new("Submarine", 2)

    refute @board.valid_placement?(sub, ["A1", "B1"])
  end

  def test_board_render_invisible_ship
    cruiser = Ship.new("Cruiser", 3)

    @board.place(cruiser, ["A1", "A2", "A3"])
    expected =
      "  1 2 3 4 \n" +
      "A . . . . \n" +
      "B . . . . \n" +
      "C . . . . \n" +
      "D . . . . \n"
    assert_equal expected, @board.render

    @board.cells["A1"].fire_upon
    expected_2 =
      "  1 2 3 4 \n" +
      "A H . . . \n" +
      "B . . . . \n" +
      "C . . . . \n" +
      "D . . . . \n"
    assert_equal expected_2, @board.render

    @board.cells["B1"].fire_upon
    expected_3 =
      "  1 2 3 4 \n" +
      "A H . . . \n" +
      "B M . . . \n" +
      "C . . . . \n" +
      "D . . . . \n"
    assert_equal expected_3, @board.render

    @board.cells["A2"].fire_upon
    @board.cells["A3"].fire_upon
    expected_4 =
      "  1 2 3 4 \n" +
      "A X X X . \n" +
      "B M . . . \n" +
      "C . . . . \n" +
      "D . . . . \n"
    assert_equal expected_4, @board.render
  end

  def test_board_render_visible_ship
    sub = Ship.new("Submarine", 2)

    @board.place(sub, ["D3", "D4"])
    expected_true =
    "  1 2 3 4 \n" +
    "A . . . . \n" +
    "B . . . . \n" +
    "C . . . . \n" +
    "D . . S S \n"
    assert_equal expected_true, @board.render(true)

    @board.cells["A1"].fire_upon
    expected_2 =
      "  1 2 3 4 \n" +
      "A M . . . \n" +
      "B . . . . \n" +
      "C . . . . \n" +
      "D . . S S \n"
    assert_equal expected_2, @board.render(true)

    @board.cells["D3"].fire_upon
    expected_3 =
      "  1 2 3 4 \n" +
      "A M . . . \n" +
      "B . . . . \n" +
      "C . . . . \n" +
      "D . . H S \n"
    assert_equal expected_3, @board.render(true)

    @board.cells["D4"].fire_upon
    expected_4 =
      "  1 2 3 4 \n" +
      "A M . . . \n" +
      "B . . . . \n" +
      "C . . . . \n" +
      "D . . X X \n"
    assert_equal expected_4, @board.render(true)
  end
end
