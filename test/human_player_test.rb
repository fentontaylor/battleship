require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/human_player'
require 'minitest/autorun'
require 'minitest/pride'

class HumanPlayerTest < Minitest::Test
  def setup
    @player = HumanPlayer.new
  end

  def test_player_exists
    assert_instance_of HumanPlayer, @player
  end

  def test_attributes
    assert_instance_of Board, @player.board
    refute_empty @player.ships
    ships = @player.ships.values
    assert_instance_of Ship, ships[0]
    assert_equal [], @player.shots_taken
  end

  def test_ship_info
    info = @player.ship_info
    expected = "- The Cruiser is 3 units long.\n" +
    "- The Submarine is 2 units long.\n"
    assert_equal expected, info
  end

  def test_place_player_ships_all_start_nil
    player_board_cells = @player.board.cells

    cell_ship_status = player_board_cells.map do |key,cell|
      player_board_cells[key].ship
    end
    assert cell_ship_status.all? {|ship| ship.nil?}


  end

  def test_place_player_ships_puts_ships_on_cells
    @player.place_player_ships
    # Manually enter 'a1 a2 a3' for cruiser, 'd3 d4' for submarine
    player_board_cells = @player.board.cells
    cell_ship_status = player_board_cells.map do |key,cell|
      player_board_cells[key].ship
    end

    refute cell_ship_status.all? {|ship| ship.nil?}
    cell_a1 = player_board_cells["A1"]
    assert_equal "Cruiser", cell_a1.ship.name
  end

  def test_already_fired_at_false_for_all_coords_in_new_game
    board = Board.new
    cells = board.cells
    all_not_fired_at = cells.none? do |cell|
      @player.already_fired_at?(cell)
    end
    assert all_not_fired_at
  end

  def test_take_shot
    board = Board.new
    ship = Ship.new("Cruiser", 3)
    board.place(ship, ['A1', 'A2', 'A3'])
    # manually enter 'A1' for coordinate to fire on
    @player.take_shot(board)

    assert_equal 2, ship.health
    assert @player.already_fired_at?('A1')
    assert_equal 'A1', @player.shots_taken.last
  end

end
