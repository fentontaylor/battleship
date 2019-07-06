require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'
require 'minitest/autorun'
require 'minitest/pride'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

end
