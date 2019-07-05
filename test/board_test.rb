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

  
end
