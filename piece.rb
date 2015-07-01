class Piece
  attr_reader :board, :color
  attr_accessor :pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos

    @board.add_piece(pos, self)
  end

  def moves
    raise "not yet implemented!"
  end

  def legal_moves
    moves.reject { |move| leaves_king_in_check?(move) }
  end

  def leaves_king_in_check?(move)
    @board.move_piece(@pos, move)
    check = @board.in_check?(@color)
    @board.undo_prev_move

    check
  end

  def piece?
    true
  end

  def colorize_piece(str)
    str.colorize(color)
  end

  def empty?
    false
  end

  def move_piece(new_pos)
    @pos = new_pos
  end

  def get_moves_from_deltas
    get_moves_from_array(deltas)
  end

  def get_moves_from_array(array)
    arr = array.map { |delta| Board.add(delta, @pos) }
    arr.select { |pos| @board.in_bounds?(pos) }
  end

  def other_color
    @color == :white ? :black : :white
  end

  def king?
    false
  end

end

class SteppingPiece < Piece

  def moves
    moves_arr = get_moves_from_deltas
    moves_arr.select { |move| valid_move?(move) }
  end

  def valid_move?(move)
    !@board.occupied_by_color?(move, color)
  end

end

class King < SteppingPiece
  def deltas
    [
      [-1, -1], [0, -1], [1, -1], [-1, 0],
      [1, 0], [-1, 1], [0, 1], [1, 1]
    ]
  end

  def to_s
    colorize_piece(" ♚ ")
  end

  def king?
    true
  end

end

class Knight < SteppingPiece
  def deltas
    [
      [1, 2], [-1, 2], [-1, -2], [1, -2],
      [2, 1], [-2, 1], [-2, -1], [2, -1]
    ]
  end

  def to_s
     colorize_piece(" ♞ ")
  end
end

class SlidingPiece < Piece

  def moves
    moves_arr = []
    move_dirs.each do |direction|
      case direction
      when :diagonal
        moves_arr += get_diagonal_moves
      when :vertical
        moves_arr += get_vertical_moves
      end
    end
    moves_arr
  end

  private
  def get_diagonal_moves
    moves = []
    [[1, 1], [-1, 1], [1, -1], [-1, -1]].each do |dir|
      moves += get_moves_in_direction(dir)
    end
    moves
  end

  def get_vertical_moves
    moves = []
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dir|
      moves += get_moves_in_direction(dir)
    end
    moves
  end

  def other_color
    color == :white ? :black : :white
  end

  def get_moves_in_direction(direction)
    current_position = Board.add(@pos, direction)
    array = []

    while valid_move?(current_position, array)
      array << current_position
      current_position = Board.add(current_position, direction)
    end

    array
  end

  def valid_move?(position, array)
    return false unless @board.in_bounds?(position)
    return false if @board.occupied_by_color?(position, color)

    prev_move = array.last
    return false if prev_move &&
      @board.occupied_by_color?(prev_move, other_color)

    true
  end

end

class Bishop < SlidingPiece
  def move_dirs
    [:diagonal]
  end

  def to_s
    colorize_piece(" ♝ ")
  end
end

class Rook < SlidingPiece
  def move_dirs
    [:vertical]
  end

  def to_s
    colorize_piece(" ♜ ")
  end
end

class Queen < SlidingPiece
  def move_dirs
    [:diagonal, :vertical]
  end

  def to_s
    colorize_piece(" ♛ ")
  end
end

class Pawn < Piece

  def initialize(color, board, position)
    super
    @original_pos = position
  end

  def moved
    @pos != @original_pos
  end

  def moves
    if color == :black
      verticals_arr = [[1, 0]]
      diagonals_arr = [[1, 1], [1, -1]]
      verticals_arr << [2, 0] unless moved
    else
      verticals_arr = [[-1, 0]]
      diagonals_arr = [[-1, 1], [-1, -1]]
      verticals_arr << [-2, 0] unless moved
    end
    verticals_arr = get_moves_from_array(verticals_arr)
    diagonals_arr = get_moves_from_array(diagonals_arr)

    verticals_arr.select! { |move| valid_move_vertical?(move) }
    diagonals_arr.select! { |move| valid_move_diagonal?(move) }

    verticals_arr + diagonals_arr
  end

  def valid_move_vertical?(move)
    !board.occupied?(move)
  end

  def valid_move_diagonal?(move)
    board.occupied_by_color?(move, other_color)
  end

  def to_s
    colorize_piece(" ♟ ")
  end

end
