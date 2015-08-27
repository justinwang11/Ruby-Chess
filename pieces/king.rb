class King < SteppingPiece
  # try making #deltas a class constant
  # use self.class::DELTAS to call it
 DELTAS =
    [
      [-1, -1], [0, -1], [1, -1], [-1, 0],
      [1, 0], [-1, 1], [0, 1], [1, 1]
    ]

  def to_s
    colorize_piece(" ♚ ")
  end

  def king?
    true
  end

end
