require_relative "empty_square"
require_relative "player"
require_relative "piece"
require_relative "board"

require "colorize"
require "byebug"
require "io/console"

class ChessGame

  def initialize(players)
    @board = players.first.board
    @players = players
  end

  def play
    until game_over
      play_turn
    end
    system("clear")
    @board.render(nil, [0,0], @winner)
    puts "Congratulations #{@winner}!"
  end

  def play_turn
    puts "#{@players[0]}'s turn'"
    move = @players.first.get_move
    @board.move_piece(*move)
    @players.rotate!
  end

  def game_over
    if @board.checkmate?(:white)
      @winner = :black
      true
    elsif @board.checkmate?(:black)
      @winner = :white
      true
    else
      false
    end
  end

end

board = Board.populate_board

player = Player.new(board, :white)
player2 = Player.new(board, :black)
chess = ChessGame.new([player, player2])
chess.play
# (from_pos, to_pos) = player.get_move
# board.move_piece(from_pos, to_pos)
# player.get_move
