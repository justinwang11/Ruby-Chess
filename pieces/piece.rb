class Piece
  attr_reader :board, :color
  attr_accessor :pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos

    @board.add_piece(pos, self)
  end

  def moves
    raise "not yet implemented!"
  end

  def legal_moves
    moves.reject { |move| leaves_king_in_check?(move) }
  end

  def empty?
    false
  end

  def move_piece(new_pos)
    @pos = new_pos
  end

  def other_color
    @color == :white ? :black : :white
  end

  def king?
    false
  end

  def add(pos1, pos2)
    [pos1[0] + pos2[0], pos1[1] + pos2[1]]
  end

  private

  def leaves_king_in_check?(move)
    @board.move_piece(@pos, move)
    check = @board.in_check?(@color)
    @board.undo_prev_move

    check
  end

  protected

  def colorize_piece(str)
    str.colorize(color)
  end

  def get_moves_from_deltas
    get_moves_from_array(self.class::DELTAS)
  end

  def get_moves_from_array(array)
    # make Board#add a Piece class method
    arr = array.map { |delta| add(delta, @pos) }
    arr.select { |pos| @board.in_bounds?(pos) }
  end

end
