require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'
require './lib/human_player'
require './lib/computer_player'
require 'minitest/autorun'
require 'minitest/pride'
require 'colorize'
require 'pry'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_all_ships_sunk?
    refute @game.all_ships_sunk?(@game.player.ships)
    3.times { @game.player.ships[:cruiser].hit }
    refute @game.all_ships_sunk?(@game.player.ships)
    2.times { @game.player.ships[:submarine].hit }
    assert @game.all_ships_sunk?(@game.player.ships)
  end

  def test_fleet_status
    actual = @game.fleet_status(@game.player)
    expected = [
      "| Cruiser: (3) |".colorize(:green),
      "| Submarine: (2) |".colorize(:green)
    ]
    assert_equal expected, actual

    3.times { @game.player.ships[:cruiser].hit }
    actual_2 = @game.fleet_status(@game.player)
    expected_2 = [
      "| Cruiser: (3) |".colorize(:red),
      "| Submarine: (2) |".colorize(:green)
    ]
    assert_equal  expected_2, actual_2
  end

  def test_report_shot_status
    skip
    @game.cpu.board
    assert_equal "My shot on B4 was a HIT!", @game.report_shot_status(@game.player.take_shot("B4"))
  end

end
