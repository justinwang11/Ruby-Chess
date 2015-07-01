require_relative "empty_square"
require_relative "player"
require_relative "piece"
require_relative "board"
require_relative "stepping_piece"
require_relative "sliding_piece"
require_relative "rook"
require_relative "bishop"
require_relative "knight"
require_relative "queen"
require_relative "king"
require_relative "pawn"
require_relative "exceptions"

require "colorize"
require "byebug"
require "io/console"
require "yaml"


class ChessGame

  def initialize(players)
    @board = players.first.board
    @players = players
  end

  def self.run
    puts "New Game (N) or Load Saved Game (L)?"
    input = $stdin.getch
    if input == "n"
      new_game
    elsif input == "l"
      load_game
    else
      self.run
    end
  end

  def self.new_game
    board = Board.populate_board
    player = Player.new(board, :white)
    player2 = Player.new(board, :black)
    chess = ChessGame.new([player, player2])
    chess.play
  end

  def self.load_game
    puts "Enter the file name"
    input = gets.chomp
    input << ".yml" unless input.end_with?(".yml")
    game = YAML::load_file(input)
    #print game
    game.play
  end

  def save_and_quit
    save_state = self.to_yaml
    puts "\nEnter the file name"
    input = gets.chomp
    input << ".yml" unless input.end_with?(".yml")
    File.open(input, "w") { |file| file.write(save_state) }
  end

  def play
    #beginning game options
    until game_over
      play_turn
    end
    system("clear")
    @board.render(nil, [0,0], @winner)
    puts "Congratulations #{@winner}!"
  rescue SaveAndQuit
    save_and_quit
  end

  private

  def play_turn
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

if __FILE__ == $PROGRAM_NAME
  ChessGame.run
end

# board = Board.populate_board
#
# player = Player.new(board, :white)
# player2 = Player.new(board, :black)
# chess = ChessGame.new([player, player2])
# chess.play
# (from_pos, to_pos) = player.get_move
# board.move_piece(from_pos, to_pos)
# player.get_move
