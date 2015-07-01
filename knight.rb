class Knight < SteppingPiece
  DELTAS =
    [
      [1, 2], [-1, 2], [-1, -2], [1, -2],
      [2, 1], [-2, 1], [-2, -1], [2, -1]
    ]

  def to_s
     colorize_piece(" ♞ ")
  end
end
