require_relative "piece.rb"
require 'byebug'
class Board
  attr_accessor :grid

  def initialize(populate = true)
    @grid = Array.new(8) {Array.new(8) {nil}}

    if populate
      populate_board(:black)
      populate_board(:white)
    end
  end

  def [](pos)
    i, j = pos

    @grid[i][j]
  end

  def []=(pos, value)
    i, j = pos

    @grid[i][j] = value
  end

  def populate_board(color)
    @grid.each_with_index do |row, row_ind|
      if color == :black
        next if row_ind > 2
      else
        next if row_ind < 5
      end

      if row_ind.even?
        row.each_with_index do |col, col_ind|
          @grid[row_ind][col_ind] =
          Piece.new([row_ind, col_ind], color, self) if col_ind.even?
        end
      else
        row.each_with_index do |col, col_ind|
          @grid[row_ind][col_ind] =
          Piece.new([row_ind, col_ind], color, self) if col_ind.odd?
        end
      end
    end
  end


  def render
    @grid.each do |row|
      #p row
      puts
      row.each do |col|
        if col.nil?
          print " . "
        elsif col.color == :black
          print " X "
        elsif col.color == :white
          print " O "
        end
      end
    end
    puts
  end

  def dup_board
    new_board = Board.new(populate = false)

    8.times do |row|
      8.times do |col|
        unless (@grid[row][col]).nil?
          old_piece = @grid[row][col]
          new_board[[row, col]] = Piece.new([row, col], old_piece.color, new_board)
        end
      end
    end

    new_board
  end

  def valid_move_sequence?(move_sequence)

    new_board = dup_board
    begin

      until move_sequence.size == 1
        start_pos = move_sequence.shift
        y, x = start_pos
        (new_board.grid[y][x]).perform_move!(move_sequence.first)
      end

    rescue InvalidMoveError => e
      puts "#{e} can't do that"
      return false
    end

    true
  end

  def perform_moves(move_sequence)
    move_seq_copy = move_sequence.dup

    if valid_move_sequence?(move_seq_copy)
      until move_sequence.size == 1
        start_pos = move_sequence.shift
        y, x = start_pos
        (@grid[y][x]).perform_move!(move_sequence.first)
      end
    else
      raise InvalidMoveError
    end

  end

end

a = Board.new

a.render
a[[2,0]].perform_slide([3,1])
a.render
a[[3,1]].perform_slide([4,2])
a.render
a[[5,1]].perform_jump([3,3])
a.render
a[[2,2]].perform_jump([4,4])
a.render
a[[1,1]].perform_slide([2,2])
a.render
puts
p a.perform_moves([[5,5],[3,3], [1,1]])
a.render
