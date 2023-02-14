# frozen_string_literal: true

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

  def game_over?(symbol, name)
    symbol_combination = @cells.map.with_index { |p, i| i if p == symbol }

    win = false
    WINNING_COMBINATIONS.each do |combination|
      next unless combination.intersection(symbol_combination).length == 3

      puts "#{name} win!"
      win = true
      break
    end

    win
  end

  def draw_symbol(symbol, position, previous_positions)
    if !previous_positions.include?(position) && position.between?(1, 9)
      previous_positions.push(position)
      @cells[position - 1] = symbol
      load_board
      return 0
    else
      puts 'INVALID MOVE, PLEASE TRY AGAIN!'.red
      return -1
    end
  end
end

class Player
  attr_reader :name, :symbol

  @@player_number = 0
  @@picked_symbol = nil
  def initialize
    @name = name
    @symbol = symbol
  end

  def pick_name
    @@player_number += 1
    puts "ENTER THE NAME OF PLAYER ##{@@player_number}:"
    @name = gets.chomp
  end

  def pick_symbol
    puts 'ENTER HIS GAME MARKER:'
    if @@picked_symbol.nil?
      @symbol = gets.chomp
      @@picked_symbol = @symbol
    else
      puts "IT CANNOT BE #{@@picked_symbol}"
      loop do
        @symbol = gets.chomp
        puts 'This Marker Already Has Been Selected!'.red if @symbol == @@picked_symbol
        break if @symbol != @@picked_symbol
      end
    end
  end
end

class TicTacToe
  def initialize
    @board = Board.new
    @player_one = Player.new
    @player_two = Player.new
    @turns = 0
    @current_player = nil
  end

  private

  def pick_players
    @player_one.pick_name
    @player_one.pick_symbol
    @player_two.pick_name
    @player_two.pick_symbol
    @current_player = @player_one
  end

  def change_current_player
    @current_player == @player_one ? @player_two : @player_one
  end

  def change_color(input)
    @current_player == @player_one ? input.cyan : input.magenta
  end

  public

  def play_game
    pick_players
    @board.load_board
    previous_positions = []
    value = nil
    x = nil
    until @turns == 9
      puts "#{change_color(@current_player.name)}, enter a number from 1 to 9 that is available to put an '#{change_color(@current_player.symbol)}'"
      position = gets.chomp.to_i
      value = @board.draw_symbol(change_color(@current_player.symbol), position, previous_positions)
      x = @board.game_over?(change_color(@current_player.symbol), @current_player.name)
      break if x == true
      if value.zero?
        @turns += 1
        @current_player = change_current_player
      end
    end
    puts 'Draw!' if x == false
  end
end

g = TicTacToe.new
g.play_game
