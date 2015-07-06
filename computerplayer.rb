class ComputerPlayer < Player

  # def get_move
  #   moves_hash = @board.all_possible_moves(@color)
  #   from_pos = moves_hash.keys.sample
  #   to_pos = moves_hash[from_pos].sample
  #   move = [from_pos, to_pos]
  # end

  def get_move
    moves_hash = @board.all_possible_moves(@color)
    values_hash = Hash.new { |hash, key| hash[key] = [] }

    moves_hash.each do |from_pos, value|
      value.each do |to_pos|
        values_hash[@board.piece_at(to_pos).value] << [from_pos, to_pos]
      end
    end

    max_value = values_hash.keys.max
    values_hash[max_value].sample
  end

end
