class Game
  attr_reader :player, :cpu
  def initialize(size = 4)
    @player = HumanPlayer.new(size)
    @cpu = ComputerPlayer.new(size)
  end

  def print_game_board(show_result = false)
    puts "\n\n"
    puts "_" * 75
    puts "___ CP BOARD #{'_' * 62}"
    print "Fleet Status: "
    puts fleet_status(@cpu).join
    puts "Shot  Status: #{report_shot_status(@cpu)}\n\n" if show_result
    puts "#{@cpu.board.render}"
    puts "_" * 75
    puts "___ PLAYER BOARD #{'_' * 58}"
    print "Fleet Status: "
    puts fleet_status(@player).join
    puts "Shot  Status: #{report_shot_status(@player)}\n\n" if show_result
    puts "#{@player.board.render(true)}"
    puts "_" * 75
  end

  def all_ships_sunk?(ships)
    status = ships.map {|key, ship| ship.sunk?}
    status.all? {|stat| stat == true}
  end

  def fleet_status(entity)
    ships = entity.ships
    status = ships.map do |key, ship|
      if ship.sunk?
        "| #{ships[key].name}: (#{ships[key].length}) |".colorize(:red)
      else
        "| #{ships[key].name}: (#{ships[key].length}) |".colorize(:green)
      end
    end
    status
  end

  def report_shot_status(entity)
    last_shot = entity.shots_taken.last
    pronoun = entity.class == HumanPlayer ? "Your" : "My"
    targeted_board =
      if entity.class == HumanPlayer
        @cpu.board
      else
        @player.board
      end
    targeted_cell = targeted_board.cells[last_shot]
    shot_result = targeted_cell.render
    shot_phrase =
      if shot_result == "\e[0;39;41mX\e[0m"
        "\u{1F480}" + "FATAL BLAST!".colorize(:background => :red) + "\u{1F480}"
      elsif shot_result == "\e[0;31;49mH\e[0m"
        "\u{1F4A5}" + "HIT!".colorize(:red) + "\u{1F4A5}"
      else
        "miss...".colorize(:light_blue)
      end
      
    "#{pronoun} shot on #{last_shot} was a #{shot_phrase}"
  end
end
