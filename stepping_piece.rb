class SteppingPiece < Piece

  def moves
    moves_arr = get_moves_from_deltas
    moves_arr.select { |move| valid_move?(move) }
  end

  private

  def valid_move?(move)
    !@board.occupied_by_color?(move, color)
  end

end
