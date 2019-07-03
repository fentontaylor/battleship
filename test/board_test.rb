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

  def test_attributes
    assert_instance_of Hash, @board.cells
    assert_equal 16, @board.cells.keys
    assert_equal 16, @board.cells.values
    assert_instance_of Cell, @board.cells["A1"]
  end
end
