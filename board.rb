

class Board

  EMPTY_SQUARE = EmptySquare.new

  def initialize
    @grid = Array.new(8) do
      Array.new(8) { EMPTY_SQUARE }
    end
    @debug = true
    @moves = []
  end

  def self.populate_row_with_pawns(color, row, board)
    8.times do |col|
      Pawn.new(color, board, [row, col])
    end
  end

  def self.populate_board
    board = Board.new
    Rook.new(:black, board, [0,0])
    Knight.new(:black, board, [0,1])
    Bishop.new(:black, board, [0,2])
    Queen.new(:black, board, [0,3])
    King.new(:black, board, [0,4])
    Bishop.new(:black, board, [0,5])
    Knight.new(:black, board, [0,6])
    Rook.new(:black, board, [0,7])

    Rook.new(:white, board, [7,0])
    Knight.new(:white, board, [7,1])
    Bishop.new(:white, board, [7,2])
    Queen.new(:white, board, [7,3])
    King.new(:white, board, [7,4])
    Bishop.new(:white, board, [7,5])
    Knight.new(:white, board, [7,6])
    Rook.new(:white, board, [7,7])

    populate_row_with_pawns(:black, 1, board)
    populate_row_with_pawns(:white, 6, board)

    board
  end

  def render(clicked, cursor, player_color)
    possible_moves = get_yellow_squares(clicked, cursor, player_color)
    print_dead_pieces(:white)
    @grid.each_with_index do |row, i|
      row.each_with_index do |square, j|
        if cursor == [i, j]
          color = :red
        elsif possible_moves.include?([i, j])
          color = :yellow
        else
          color = (i + j) % 2 == 0 ? :blue : :magenta
        end
        print square.to_s.colorize(:background => color)
      end
      puts
    end
    print_dead_pieces(:black)
    print_instructions
    print_debug_stuff
  end

  def captured_pieces
    pieces = @moves.map { |item| item.last }
    pieces.select { |piece| !piece.empty? }
  end

  def checkmate?(color)
    if in_check?(color)
      no_moves?(color)
    else
      false
    end
  end

  def no_moves?(color)
    get_pieces(color).map(&:legal_moves).flatten.empty?
  end

  def in_check?(color)
    king_location = find_king(color)
    get_pieces(other_color(color)).any? do |piece|
      piece.moves.include?(king_location)
    end
  end

  def occupied?(pos)
    !piece_at(pos).empty?
  end

  def occupied_by_color?(pos, color)
    if occupied?(pos)
      return piece_at(pos).color == color
    end
    false
  end

  def move_piece(from_pos, to_pos)
    piece = piece_at(from_pos)
    raise Exception if piece.empty?

    @moves << [from_pos, to_pos, piece_at(to_pos)]
    add_piece(to_pos, piece)
    add_piece(from_pos, EMPTY_SQUARE)
    piece.move_piece(to_pos)
  end

  def undo_prev_move
    from_pos, to_pos, captured_piece = @moves.pop
    piece = piece_at(to_pos)

    add_piece(from_pos, piece)
    add_piece(to_pos, captured_piece)
    piece.move_piece(from_pos)
  end

  def all_possible_moves(color)
    move_hash = Hash.new
    get_pieces(color).each do |piece|
      move_hash[piece.pos] = piece.legal_moves
    end
    move_hash.reject! { |pos, arr| arr.empty? }
    move_hash
  end

  def piece_at(pos)
    @grid[pos[0]][pos[1]]
  end

  def add_piece(pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end

  def in_bounds?(pos)
    pos.all? { |n| n.between?(0, 7) }
  end

  private

  def other_color(color)
    color == :white ? :black : :white
  end

  def find_king(color)
    @grid.each_with_index do |row, i|
      row.each_with_index do |square, j|
        return [i, j] if square.king? && square.color == color
      end
    end
    raise "There should be a king"
    nil
  end

  def get_pieces(color)
    pieces_arr = []
    @grid.each_with_index do |row, i|
      row.each_with_index do |square, j|
        pieces_arr << square if !square.empty? && square.color == color
      end
    end
    pieces_arr
  end

  def get_yellow_squares(clicked, cursor, color)
    current_square = clicked.nil? ? piece_at(cursor) : piece_at(clicked)
    if !current_square.empty? && current_square.color == color
      current_square.legal_moves
    else
      []
    end
  end

  def debug_find_black_queen
    @grid.each_with_index do |row, i|
      row.each_with_index do |square, j|
        return square if square.is_a?(Queen) && square.color == :black
      end
    end
  end

  def print_dead_pieces(color)
    dead_pieces = captured_pieces.select { |piece| piece.color == color }
    background_color = :light_green

    2.times do
      8.times do
        piece = dead_pieces.shift
        if piece.nil?
          print "   ".colorize(:background => background_color)
        else
          print piece.to_s.colorize(:background => background_color)
        end
      end
      puts
    end
  end

  def print_instructions
    puts "W,A,S,D => move cursor"
    puts "ENTER to select and move pieces"
    puts "Q => quit"
    puts "V => save & quit"
    puts "L => load saved game"
  end

  def print_debug_stuff
    if @debug
      puts in_check?(:black)
      puts in_check?(:white)
      p king = find_king(:white)
      p king.class

      # bq = debug_find_black_queen
      # p bq.moves
      # p bq.pos

      p piece_at(find_king(:white)).legal_moves
      p no_moves?(:white)
    end
  end

end
