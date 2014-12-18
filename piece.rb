#require_relative "board.rb"

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

  def perform_move(start_pos, end_pos)

  end

  # def valid_slide?(end)
  #
  # end

  def valid_move?(pos)
    pos.each do |coord|
      return false if coord > 7 || coord < 0
    end
    true
  end

  def perform_slide(end_pos)
    return "that's no on the board!" unless valid_move?(end_pos)
    return "there's already a piece there" unless @grid[end_pos].nil?

    puts " before slide my position is #{@pos}"

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
    else
      false
    end

    maybe_promote
  end

  def perform_jump(end_pos)
    return "that's no on the board!" unless valid_move?(end_pos)
    return "there's already a piece there" unless @grid[end_pos].nil?

    jumps = move_dirs.map {|arr| arr.map { |el| el*2}}

    sy, sx = pos

    #find if enemy nearby:
    # jump_dirs = []
    # move_dirs.each do |potential_dir|
    #   dy, dx = potential_dir
    #   scoped_move = [sy + dy, sx + dx]
    #   if @grid[scoped_move] != nil && @grid[scoped_move].color != color
    #     jump_dirs << [sy + (dy*2), sx + (dx*2)] #adds
    #   end
    # end

    #find potential jump positions
    jumps.each do |potential_dir|
      dy, dx = potential_dir
      potential_moves << [sy + dy, sx + dx]
    end
    #
    if potential_moves.include?(end_pos)
      @grid[end_pos] = @grid[@pos]
      @grid[@pos] = nil
      @pos = end_pos
    else
      false
    end
    #   #check if peice in between
    # end
  end

  def maybe_promote
    @king = true if color == :black && @pos[0] == 7
    @king = true if color == :white && @pos[0] == 0
  end


  def inspect
    "the checker at #{@pos} is #{@color}"
  end
end
