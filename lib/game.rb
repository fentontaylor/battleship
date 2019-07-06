require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'
require "pry"

class Game
  attr_reader :cp_board, :pl_board, :cp_ships, :pl_ships


  def initialize
    @cp_board = Board.new
    @pl_board = Board.new
    @cp_ships = {cruiser: Ship.new('Cruiser', 3), submarine: Ship.new('Submarine', 2)}
    @pl_ships = {cruiser: Ship.new('Cruiser', 3), submarine: Ship.new('Submarine', 2)}

  end

  def play_game
    print "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit. --> "
    selection = gets.chomp

    if selection.downcase == 'p'
    puts "You are now playing BATTLESHIP\n\n"
    puts @cp_board.render
    end
  end
end

game = Game.new
