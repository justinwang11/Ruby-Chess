class Queen < SlidingPiece
  def move_dirs
    [:diagonal, :vertical]
  end

  def to_s
    colorize_piece(" ♛ ")
  end
end
