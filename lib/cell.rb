class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship.nil?
  end

  def fired_upon?
    @fired_upon
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
    unless fired_upon?
      unless empty?
        @ship.hit
      end
      @fired_upon = true
    end
  end

  def render(show_ship = false)
    if fired_upon?
      if empty?
        "M".colorize(:light_blue)
      else
        @ship.sunk? ? "X".colorize(:background => :red) : "H".colorize(:red)
      end
    else
      show_ship && !empty? ? "S".colorize(:green) : ".".colorize(:blue)
    end
  end
end
