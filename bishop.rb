class Bishop < SlidingPiece
  def move_dirs
    [:diagonal]
  end

  def to_s
    colorize_piece(" ♝ ")
  end
end
