require "minitest/autorun"
require "minitest/pride"
require "./lib/ship"

class ShipTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
  end


  def test_ship_exist
    assert_instance_of Ship, @cruiser
  end

  def test_attributes
    assert_equal "Cruiser", @cruiser.name

    assert_equal 3, @cruiser.length

    assert_equal 3, @cruiser.health

    refute @cruiser.sunk?
  end

  def test_hit
    @cruiser.hit
    assert_equal 2, @cruiser.health

    @cruiser.hit
    assert_equal 1, @cruiser.health
  end

  def test_reducing_health_to_0_sinks_the_ship
    3.times { @cruiser.hit }
    assert @cruiser.sunk?
  end
end
