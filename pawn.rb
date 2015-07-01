class Pawn < Piece

  def initialize(color, board, position)
    super
    @original_pos = position
  end

  def moves
    direction = @color == :black ? 1 : -1

    verticals_arr = [[direction * 1, 0]]
    diagonals_arr = [[direction * 1, 1], [direction * 1, -1]]
    verticals_arr << [direction * 2, 0] unless moved

    verticals_arr = get_moves_from_array(verticals_arr)
    diagonals_arr = get_moves_from_array(diagonals_arr)

    verticals_arr.select! { |move| valid_move_vertical?(move) }
    diagonals_arr.select! { |move| valid_move_diagonal?(move) }

    verticals_arr + diagonals_arr
  end

  def to_s
    colorize_piece(" ♟ ")
  end

  private

  def valid_move_vertical?(move)
    !board.occupied?(move)
  end

  def valid_move_diagonal?(move)
    board.occupied_by_color?(move, other_color)
  end

  def moved
    @pos != @original_pos
  end

end
