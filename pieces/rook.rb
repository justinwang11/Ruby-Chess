class Rook < SlidingPiece
  def move_dirs
    [:vertical]
  end

  def to_s
    colorize_piece(" ♜ ")
  end

  def value
    5
  end
end
