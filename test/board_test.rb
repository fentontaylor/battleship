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

  def test_default_size_is_4
    assert_equal 4, @board.size
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
end
