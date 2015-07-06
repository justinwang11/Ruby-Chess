class GameNodes

  def initialize(board, move, color, depth)
    @board = board
    @move = move
    @color = color
    @depth = depth
  end

  def self.minimax(board, color, maximizing, depth)
    if depth == 0
      heuristic(board, color)
    elsif
  end

  def self.heuristic(board, color)
    @board.captured_pieces.inject(0) do |sum, piece|
      if piece.color == color
        sum + piece.value
      else
        sum - piece.value
      end
    end
  end

end
