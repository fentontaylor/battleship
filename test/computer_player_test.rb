require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/computer_player'
require 'minitest/autorun'
require 'minitest/pride'
require "pry"

class ComputerPlayerTest < Minitest::Test
  def setup
    @cpu = ComputerPlayer.new
  end

  def test_cpu_exists
    assert_instance_of ComputerPlayer, @cpu
    end

  def test_attributes
    assert_instance_of Board, @cpu.board
    refute_empty @cpu.ships
    ships = @cpu.ships.values
    assert_instance_of Ship, ships[0]
  end

  def test_place_cpu_ships_all_start_nil
    cpu_board_cells = @cpu.board.cells

    cell_ship_status = cpu_board_cells.map do |key,cell|
      cpu_board_cells[key].ship
    end
    assert cell_ship_status.all? {|ship| ship.nil?}
  end

  def test_place_cpu_ships_puts_ships_on_cells
    @cpu.place_cp_ships
    cpu_board_cells = @cpu.board.cells
    cell_ship_status = cpu_board_cells.map do |key, cell|
      cpu_board_cells[key].ship
    end

    refute cell_ship_status.all? {|ship| ship.nil?}
    assert cell_ship_status.any? {|ship| ship.class == Ship}

    actual =
      cpu_board_cells.count do |key, cell|
        unless cell.ship.nil?
          cell.ship.name == 'Cruiser'
        end
      end
    assert_equal 3, actual

    actual_2 =
      cpu_board_cells.count do |key, cell|
        unless cell.ship.nil?
          cell.ship.name == 'Submarine'
        end
      end
    assert_equal 2, actual_2

  end

  def test_take_shot
    board = Board.new
    2.times { @cpu.take_shot(board) }
    assert_equal 2, @cpu.shots_taken.length

    actual = board.cells.select {
      |cell| board.cells[cell].fired_upon?
    }

    assert_equal 2, actual.length
  end

  def test_computer_cant_shoot_at_same_cell_twice
    board = Board.new
    16.times { @cpu.take_shot(board) }
    assert_equal 16, @cpu.shots_taken.uniq.length
  end

end
