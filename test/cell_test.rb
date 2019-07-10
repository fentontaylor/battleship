require './lib/cell'
require './lib/ship'
require 'minitest/autorun'
require 'minitest/pride'
require 'colorize'

class CellTest < Minitest::Test

  def setup
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)

  end

  def test_cell_exists
    assert_instance_of Cell, @cell
  end

  def test_attributes
    assert_equal "B4", @cell.coordinate
    assert_nil @cell.ship
  end

  def test_empty?
    assert @cell.empty?
  end

  def test_place_ship
    @cell.place_ship(@cruiser)
    assert_instance_of Ship, @cell.ship
    refute @cell.empty?
  end

  def test_fired_upon?
    refute @cell.fired_upon?
  end

  def test_fire_upon
    @cell.place_ship(@cruiser)
    @cell.fire_upon
    assert_equal 2, @cell.ship.health
    assert @cell.fired_upon?
  end

  def test_render_if_no_ship_present
    assert_equal "\e[0;34;49m.\e[0m", @cell.render
    assert_equal "\e[0;34;49m.\e[0m", @cell.render(true)
    @cell.fire_upon
    assert_equal "\e[0;94;49mM\e[0m", @cell.render
  end

  def test_render_if_ship_present
    @cell.place_ship(@cruiser)
    assert_equal "\e[0;34;49m.\e[0m", @cell.render
    assert_equal "\e[0;32;49mS\e[0m", @cell.render(true)
    @cell.fire_upon
    assert_equal "\e[0;31;49mH\e[0m", @cell.render
  end

  def test_render_when_a_hit_sinks_the_ship
    @cell.place_ship(@cruiser)
    2.times { @cell.ship.hit }
    @cell.fire_upon
    assert_equal "\e[0;39;41mX\e[0m", @cell.render
  end
end
