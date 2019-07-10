require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'
require './lib/human_player'
require './lib/computer_player'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_all_ships_sunk?
    refute @game.all_ships_sunk?(@game.player.ships)
  end


end
