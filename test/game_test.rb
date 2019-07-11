require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'
require './lib/human_player'
require './lib/computer_player'
require 'minitest/autorun'
require 'minitest/pride'
require 'colorize'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
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
    assert_equal expected_2, actual_2

    2.times { @game.player.ships[:submarine].hit }
    actual_3 = @game.fleet_status(@game.player)
    expected_3 = [
      "| Cruiser: (3) |".colorize(:red),
      "| Submarine: (2) |".colorize(:red)
    ]
    assert_equal expected_3, actual_3
  end

  def test_report_shot_status
    ship = Ship.new("Submarine", 2)
    board = @game.cpu.board
    board.place(ship, ['A1', 'A2'])

    puts "ENTER B1" # Enter B1 when prompted
    @game.player.take_shot(@game.cpu.board)
    expected =
      'Your shot on B1 was a ' +
      'miss...'.colorize(:light_blue)
    actual = @game.report_shot_status(@game.player)
    assert_equal expected, actual

    puts "ENTER A1" # Enter A1 when prompted
    @game.player.take_shot(@game.cpu.board)
    expected_2 =
      'Your shot on A1 was a ' +
      "\u{1F4A5}" +
      "HIT!".colorize(:red) +
      "\u{1F4A5}"
    actual_2 = @game.report_shot_status(@game.player)
    assert_equal expected_2, actual_2

    puts "ENTER A2" # Enter A2 when prompted
    @game.player.take_shot(@game.cpu.board)
    expected_3 =
      'Your shot on A2 was a ' +
      "\u{1F480}" +
      "FATAL BLAST!".colorize(:background => :red) +
      "\u{1F480}"
    actual_3 = @game.report_shot_status(@game.player)
    assert_equal expected_3, actual_3
  end

end
