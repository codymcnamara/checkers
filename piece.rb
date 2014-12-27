#require_relative "board.rb"
class InvalidMoveError < StandardError
end

class Piece
  attr_accessor :king, :color, :pos
  attr_reader :grid

  def initialize(pos, color, grid)
    @pos, @color, @grid =  pos, color, grid

    @king = false
  end

  def move_dirs
    [[1, -1], [1, 1], [-1, -1],[-1, 1]] if @king
    if color == :black
      [[1, -1], [1, 1]]
    elsif color == :white
      [[-1, -1],[-1, 1]]
    end
  end

  def perform_move!(end_pos)
    if perform_slide(end_pos) # if this is true next
    elsif perform_jump(end_pos) # if this is true next
    else
      raise InvalidMoveError
    end
    #
    # move_sequence.each do |start_pos, end_pos|
    #   if @grid[start_pos].perform_slide(end_pos) # if this is true next
    #   elsif @grid[start_pos].perform_jump(end_pos) # if this is true next
    #   else
    #     raise InvalidMoveError
    #   end
    # end
    # puts "sequence properly executed"
  end


  def perform_slide(end_pos)

    if !valid_move?(end_pos) || @grid[end_pos] != nil
      return false
    else
      potential_moves = []
      sy, sx = @pos

      move_dirs.each do |potential_dir|
        dy, dx = potential_dir
        potential_moves << [sy + dy, sx + dx]
      end

      if potential_moves.include?(end_pos)
        @grid[end_pos] = @grid[@pos]
        @grid[@pos] = nil
        @pos = end_pos
        maybe_promote
        return true
      end

      false
    end

  end

  def perform_jump(end_pos)

    if !valid_move?(end_pos) || @grid[end_pos] != nil
      return false
    else
      sy, sx = pos

      jump_dirs_pairs = []
      move_dirs.each do |potential_dir|
        dy, dx = potential_dir
        scoped_move = [sy + dy, sx + dx]
        if @grid[scoped_move] != nil && @grid[scoped_move].color != color
          jump_dirs_pairs << [[sy + (dy*2), sx + (dx*2)], [sy + dy, sx + dx]]
          #^first position is jumping coordinate, second is thing it's jumping over
        end
      end

      jump_dirs_pairs.each do |pair|
        if pair[0] == end_pos #if potential jumping position matches end_pos
          @grid[end_pos] = @grid[@pos]
          @grid[@pos] = nil
          @grid[pair[1]] = nil #get rid of piece that got jumped over
          @pos = end_pos
          maybe_promote
          return true
        end
      end

      false
    end
  end

  def maybe_promote
    @king = true if color == :black && @pos[0] == 7
    @king = true if color == :white && @pos[0] == 0
  end

  def valid_move?(pos)
    pos.each do |coord|
      return false if coord > 7 || coord < 0
    end
    true
  end

  def inspect
    "the checker at #{@pos} is #{@color}"
  end
end


#if time use colorize gem

#puts " before slide my position is #{@pos}"
