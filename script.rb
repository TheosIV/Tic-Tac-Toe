class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
end

class Board
    def initialize
        @cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    end

    def load_board
        puts <<-board
                #{@cells[0]} | #{@cells[1]} | #{@cells[2]}
               ---+---+---
                #{@cells[3]} | #{@cells[4]} | #{@cells[5]}
               ---+---+---
                #{@cells[6]} | #{@cells[7]} | #{@cells[8]}
             board
    end

    def draw_symbol(symbol, position, previous_positions)
        if !previous_positions.include?(position) && position.between?(1, 9)
            previous_positions.push(position)
            @cells[position - 1] = symbol
            load_board
            return 0
        else
            puts "INVALID MOVE, PLEASE TRY AGAIN!".red
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
        if @@picked_symbol == nil
            puts "ENTER HIS GAME MARKER:"
            @symbol = gets.chomp
            @@picked_symbol = @symbol
        else
            puts "ENTER HIS GAME MARKER:"
            puts "IT CANNOT BE #{@@picked_symbol}"
            loop do
                @symbol = gets.chomp
                if @symbol == @@picked_symbol
                    puts "This Marker Already Has Been Selected!".red
                end
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
        @turns = 1
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
    def current_player_name_color
        @current_player == @player_one ? @current_player.name.cyan : @current_player.name.magenta
    end
    def current_player_symbol_color
        @current_player == @player_one ? @current_player.symbol.cyan : @current_player.symbol.magenta
    end
    public
    def play_game
        pick_players
        @board.load_board
        previous_positions = []
        symbols_positions = [] #
        value = nil
        until @turns == 9
            puts "#{current_player_name_color}, enter a number from 1 to 9 that is available to put an '#{@current_player.symbol}'"
            position = gets.chomp.to_i
            symbols_positions[position - 1] = @current_player.symbol #
            value = @board.draw_symbol(current_player_symbol_color, position, previous_positions)
            outcome = game_outcome(symbols_positions, @current_player.symbol, @current_player.name) #
            break if outcome == 0
            if value == 0
                @turns += 1
                @current_player = change_current_player
            end
        end
    end

    private
    def game_outcome(symbols_positions, symbol, name)
        wining_combinations = [[0, 1, 2], [3, 4 ,5], [6, 7, 8],
                                [0, 3, 6], [1, 4, 7], [2, 5, 8],
                                [0, 4, 8], [2, 4, 6]
                               ]
        symbol_indexes = symbols_positions.map.with_index {|p, i| p == symbol ? i : nil}
        win = false
        wining_combinations.each do |combination|
            combination.intersection(symbol_indexes).length == 3 ? win = true : nil
        end
        if win == false && @turns == 9
            puts "DRAW!"
            return 0
        end
        case win
        when true 
            puts "#{name} wins!"
            return 0
        else
            nil
        end
    end
end

g = TicTacToe.new
g.play_game