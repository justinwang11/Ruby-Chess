require "byebug"

class Player
  attr_reader :clicked, :board

  def initialize(board, color)
    @clicked = nil
    @cursor = [0,0]
    @board = board
    @color = color
  end

  MOVEMENTS = {
    "a" => [0, -1],
    "s" => [1, 0],
    "w" => [-1, 0],
    "d" => [0, 1]
  }

  ACTIONS = {
    "q" => :quit_game,
    "\r" => :click_space,
    "v" => :save_quit
  }

  def get_move
    @move = nil
    while @move.nil? || !valid_move?
      system("clear")
      @board.render(@clicked, @cursor, @color)
      # byebug
      input = $stdin.getch

      if MOVEMENTS.keys.include?(input)
        new_cursor_position(input)
      elsif ACTIONS.keys.include?(input)
        do_action(input)
      end
    end

    @clicked = nil
    @move
  end

  def valid_move?
    from_pos, to_pos = @move
    piece = @board.piece_at(from_pos)

    piece.legal_moves.include?(to_pos)
  end

  def quit_game
    exit
  end

  def click_space
    if @clicked.nil? && @board.occupied_by_color?(@cursor, @color) &&
      !@board.piece_at(@cursor).legal_moves.empty?
      @clicked = @cursor
    elsif @clicked.nil?
      #do nothing
    elsif @clicked == @cursor
      @clicked = nil
    elsif
      @move = [@clicked, @cursor]
    end
  end

  def save_quit
    raise SaveAndQuit
  end

  private

  def new_cursor_position(input)
    move = MOVEMENTS[input]
    new_pos = [@cursor[0] + move[0], @cursor[1] + move[1]]
    new_pos.each_with_index do |num, i|
      if num < 0
        new_pos[i] = 0
      elsif num > 7
        new_pos[i] = 7
      end
    end
    @cursor = new_pos
  end

  def do_action(input)
    send(ACTIONS[input])
  end

end
