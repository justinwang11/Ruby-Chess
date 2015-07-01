class Rook < SlidingPiece
  def move_dirs
    [:vertical]
  end

  def to_s
    colorize_piece(" ♜ ")
  end
end
