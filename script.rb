# frozen_string_literal: true

# String Class
class String
  def black
    "\e[30m#{self}\e[0m"
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def brown
    "\e[33m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end

  def magenta
    "\e[35m#{self}\e[0m"
  end

  def cyan
    "\e[36m#{self}\e[0m"
  end

  def gray
    "\e[37m#{self}\e[0m"
  end
end

# Class for board
class Board
  WINNING_COMBINATIONS = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                          [0, 3, 6], [1, 4, 7], [2, 5, 8],
                          [0, 4, 8], [2, 4, 6]].freeze
  def initialize
    @cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  def load_board
    puts <<-BOARD
                #{@cells[0]} | #{@cells[1]} | #{@cells[2]}
               ---+---+---
                #{@cells[3]} | #{@cells[4]} | #{@cells[5]}
               ---+---+---
                #{@cells[6]} | #{@cells[7]} | #{@cells[8]}
    BOARD
  end

  def win?(symbol, name)
    symbol_combination = @cells.map.with_index { |p, i| i if p == symbol }
    win = false
    WINNING_COMBINATIONS.each do |combination|
      next unless combination.intersection(symbol_combination).length == 3

      puts "\n#{name} win!".green
      win = true
      break
    end
    win
  end

  def legal_move?(position)
    true if position.is_a?(Numeric) && @cells[position - 1].is_a?(Numeric)
  end

  def draw_symbol(symbol, position)
    @cells[position - 1] = symbol
    load_board
  end
end

# Class for players
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def player_move
    puts "\n\n#{name}, Choose - from 1 to 9 - Where Would You Like To Place #{symbol}:"
    position = gets.chomp.to_i
    until position.between?(1, 9)
      puts 'Invalid Move'.red
      position = gets.chomp.to_i
    end
    position
  end
end

# Class for the game
class TicTacToe
  attr_reader :player_one, :player_two, :current_player, :turns, :board

  def initialize
    @board = Board.new
    @player_one = nil
    @player_two = nil
    @current_player = nil
    @turns = 0
    play
  end

  private

  def asign_player_one
    puts 'Enter The Name Of Player #1:'
    @player_one = Player.new(gets.chomp, 'o')
    @current_player = @player_one
  end

  def asign_player_two
    puts "\nEnter The Name Of Player #2:"
    @player_two = Player.new(gets.chomp, 'x')
  end

  def change_current_player
    current_player == player_one ? player_two : player_one
  end

  def change_color(input)
    current_player == player_one ? input.cyan : input.magenta
  end

  def play_turn
    move = current_player.player_move
    until board.legal_move?(move)
      puts 'Invalid Move'.red
      move = current_player.player_move
    end
    move
  end

  def draw
    puts "\nDRAW!".green if turns == 9
  end

  def play_again?
    puts "\nPress 'Y' to play again or 'N' to exit:"
    answer = gets.chomp.downcase until %w[y n].include?(answer)
    TicTacToe.new if answer == 'y'
    puts "\nSee you another time!" if answer == 'n'
  end

  def turns_loop
    until turns == 9
      board.draw_symbol(change_color(current_player.symbol), play_turn)
      break if board.win?(change_color(current_player.symbol), current_player.name)

      @current_player = change_current_player
      @turns += 1
    end
  end

  def play
    puts "\n\nNEW TIC-TAC-TOE GAME!\n\n".blue
    asign_player_one
    asign_player_two
    board.load_board
    turns_loop
    draw
    play_again?
  end
end

TicTacToe.new
