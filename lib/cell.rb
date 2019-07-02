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
    unless empty?
      @ship.hit
    end
    @fired_upon = true
  end

  def render(show_ship = false)
    if fired_upon?
      if empty?
        "M"
      else
        unless @ship.sunk?
          "H"
        else
          "X"
        end
      end
    else
      if show_ship
        "S"
      else
        "."
      end
    end
  end

end
