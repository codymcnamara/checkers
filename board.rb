require_relative "piece.rb"

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

  end



end

a = Board.new
#a.render
#p a.[[0, 1]].nil?
#p a.valid_move?([-1,0])
#p a.square_empty?[0,1]
a.render
a[[2,0]].perform_slide([3,1])
a.render
a[[3,1]].perform_slide([4,2])
a.render
a[[5,1]].perform_jump([3,3])
a.render
