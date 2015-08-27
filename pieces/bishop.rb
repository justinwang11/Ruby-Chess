class Bishop < SlidingPiece
  def move_dirs
    [:diagonal]
  end

  def to_s
    colorize_piece(" ♝ ")
  end

  def value
    3
  end
end
