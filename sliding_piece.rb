class SlidingPiece < Piece

  DIAGONAL_DELTAS = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  VERTICAL_DELTAS = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  
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
    DIAGONAL_DELTAS.each do |dir|
      moves += get_moves_in_direction(dir)
    end
    moves
  end

  def get_vertical_moves
    moves = []
    VERTICAL_DELTAS.each do |dir|
      moves += get_moves_in_direction(dir)
    end
    moves
  end

  def get_moves_in_direction(direction)
    current_position = add(@pos, direction)
    array = []

    while valid_move?(current_position, array)
      array << current_position
      current_position = add(current_position, direction)
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
