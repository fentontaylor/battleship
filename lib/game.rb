class Game
  attr_reader :player, :cpu
  def initialize(size = 4)
    @player = HumanPlayer.new(size)
    @cpu = ComputerPlayer.new(size)
  end

  def play_game
    @cpu.place_cp_ships

    puts "\n\u{26F5} You are now playing BATTLESHIP \u{26F5}\n\n" +
    "I have placed my ships on the grid.\n" +
    "You now need to place your #{@player.ships.size} ships.\n"

    @player.place_player_ships
    puts print_game_board

    until all_ships_sunk?(@cpu.ships) || all_ships_sunk?(@player.ships)
      @player.take_shot(@cpu.board)

      unless all_ships_sunk?(@cpu.ships)
        @cpu.take_shot(@player.board)
      end

      print_game_board(true)
    end

    if all_ships_sunk?(@cpu.ships)
      puts "\n \u{1F604} YOU WON! \u{1F604}\n\n"
    else
      puts "\n \u{1F61D} BWAHAHA, I WIN! \u{1F61D}\n"
    end
  end
end

def print_game_board(result = false)
  puts "\n\n"
  puts "_" * 75
  if result
    puts "___ CP BOARD #{'_' * 62}"
    print "Fleet Status: "
    puts fleet_status(@cpu).join
    puts "Shot  Status: #{report_shot_status(@cpu)}\n\n"
  else
    puts "___ CP BOARD #{'_' * 62}"
  end
  puts "#{@cpu.board.render}\n"
  puts "_" * 75
  if result
    puts "___ PLAYER BOARD #{'_' * 58}"
    print "Fleet Status: "
    puts fleet_status(@player).join
    puts "Shot  Status: #{report_shot_status(@player)}\n\n"
  else
    puts "___ PLAYER BOARD #{'_' * 58}"
  end
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
      "| #{ships[key].name}: #{ships[key].length} units |".colorize(:red)
    else
      "| #{ships[key].name}: #{ships[key].length} units |".colorize(:green)
    end
  end
  status
end

def report_shot_status(entity)
  last_shot = entity.shots_taken.last
  pronoun = entity.class == HumanPlayer ? "Your" : "My"
  targeted_board = if entity.class == HumanPlayer
      @cpu.board
    else
      @player.board
    end
  targeted_cell = targeted_board.cells[last_shot]
  shot_result = targeted_cell.render
  shot_phrase = if shot_result == "\e[0;39;41mX\e[0m"
      "FATAL BLAST!".colorize(:background => :red)
    elsif shot_result == "\e[0;31;49mH\e[0m"
      "HIT!".colorize(:red)
    else
      "miss...".colorize(:light_blue)
    end
  "#{pronoun} shot on #{last_shot} was a #{shot_phrase}"
end
