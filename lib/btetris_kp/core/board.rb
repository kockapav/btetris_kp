require 'btetris_kp/menu'
require 'btetris_kp/core/piece'

module BTetrisKp
  # class representing one tetris board
  class Board
    attr_accessor :board, :cur_piece

    def initialize(window, posx, posy)
      @window = window
      @tile_size = @window.width / 30

      # board corners position
      @posx = posx
      @posx2 = posx + Const::PNR_HOR * @tile_size
      @posy = posy
      @posy2 = posy + Const::PNR_VER * @tile_size

      # initializes board array and current piece
      @board = Array.new(Const::PNR_VER) { Array.new(Const::PNR_HOR, 0) }
      @cur_piece = Piece.new(@board, 0, Const::PNR_HOR / 3 + 1, rand(Const::TILES.size))
    end

    # generates new piece,
    # current piece is set on board and replaced by new one
    def new_piece!
      @cur_piece.set_on_board
      @cur_piece = Piece.new(@board, 0, Const::PNR_HOR / 3 + 1, rand(Const::TILES.size))
    end

    # checks whether piece can move down
    def piece_stuck?
      @cur_piece.move_down!
      can_be_set = @cur_piece.can_be_set?
      @cur_piece.move_up!
      !can_be_set
    end

    # moves piece left
    def piece_left!
      @cur_piece.move_left!
      @cur_piece.move_right! unless @cur_piece.can_be_set?
    end

    # moves piece right
    def piece_right!
      @cur_piece.move_right!
      @cur_piece.move_left! unless @cur_piece.can_be_set?
    end

    # moves piece down faster
    def piece_down!
      @cur_piece.move_down!
      @cur_piece.move_up! unless @cur_piece.can_be_set?
    end

    # rotates piece, returns true when successful
    def piece_rotate!
      @cur_piece.rotate_right!
      return true if @cur_piece.can_be_set?
      @cur_piece.rotate_left!
      false
    end

    # drops peace down as far as possible
    def piece_drop!
      @cur_piece.move_down! while @cur_piece.can_be_set?
      @cur_piece.move_up!
    end

    # next step of game, returns count of cleared rows
    def next_step!
      cnt = 0
      @cur_piece.move_down!
      unless @cur_piece.can_be_set?
        @cur_piece.move_up!
        new_piece!
        cnt = clear_rows!
      end
      cnt
    end

    # copies content of one row into another
    # r1 - source row, r2 - destination row
    def copy_row(r1, r2)
      if r1 < 0
        @board[r2].each_with_index { |val, index| @board[r2][index] = 0 }
      else
        @board[r1].each_with_index { |val, index| @board[r2][index] = val }
      end
    end

    # fills row randomly with blocks and spaces
    # atleast one block has to be empty space
    def fill_row_randomly(index)
      @board[index].each_with_index do |val, x|
        @board[index][x] = rand(Const::TILE_COLORS_NR + 1)
      end
      @board[index][rand(Const::PNR_HOR)] = 0
    end

    # inserts garbage in board depending on count of cleared rows
    def insert_garbage!(cnt)
      for index in cnt.upto(Const::PNR_VER - 1)
        copy_row(index, index - cnt)
      end
      for index in (Const::PNR_VER - cnt).upto(Const::PNR_VER - 1)
        fill_row_randomly(index)
      end
    end

    # moves down all rows with smaller index then row_index,
    # removing row at row_index content in the process
    def clear_row!(row_index)
      for index in row_index.downto(0) do
        copy_row(index - 1, index)
      end
    end

    # clears rows that are full, returns number of cleared rows
    def clear_rows!
      cnt = 0
      @board.each_with_index do |row, index|
        unless row.include?(0)
          clear_row!(index)
          cnt += 1
        end
      end
      cnt
    end

    # checks if game is over
    def game_over?
      !@cur_piece.can_be_set?
    end

    # draws board border and background
    def draw_background
      @window.draw_quad(@posx, @posy, Const::BOARD_BACK_CLR,
                        @posx2, @posy, Const::BOARD_BACK_CLR,
                        @posx,  @posy2, Const::BOARD_BACK_CLR,
                        @posx2, @posy2, Const::BOARD_BACK_CLR)
      @window.draw_line(@posx - 1, @posy - 1, Const::BOARD_CLR,
                        @posx2 + 1, @posy - 1, Const::BOARD_CLR)
      @window.draw_line(@posx2 + 1, @posy - 1, Const::BOARD_CLR,
                        @posx2 + 1, @posy2 + 1, Const::BOARD_CLR)
      @window.draw_line(@posx - 1, @posy - 1, Const::BOARD_CLR,
                        @posx - 1, @posy2 + 1, Const::BOARD_CLR)
      @window.draw_line(@posx - 1, @posy2 + 1, Const::BOARD_CLR,
                        @posx2 + 1, @posy2 + 1, Const::BOARD_CLR)
    end

    # draws block on board
    def draw_block(x, y, val)
      unless val == 0
        x1 = @posx + x * @tile_size
        x2 = @posx + (x + 1) * @tile_size
        y1 = @posy + y * @tile_size
        y2 = @posy + (y + 1) * @tile_size

        @window.draw_quad(x1, y1, Const::TILE_COLORS[val],
                          x2, y1, Const::TILE_COLORS[val],
                          x1, y2, Const::TILE_COLORS[val],
                          x2, y2, Const::TILE_COLORS[val])

        @window.draw_line(x2 - 1, y1 + 1, Const::TILE_SHADOW_CLR[val],
                          x2 - 1, y2 - 1, Const::TILE_SHADOW_CLR[val])
        @window.draw_line(x1 + 1 , y2 - 1, Const::TILE_SHADOW_CLR[val],
                          x2 - 1, y2 - 1, Const::TILE_SHADOW_CLR[val])
        @window.draw_line(x2, y1, Const::TILE_SHADOW_CLR[val],
                          x2, y2, Const::TILE_SHADOW_CLR[val])
        @window.draw_line(x1, y2, Const::TILE_SHADOW_CLR[val],
                          x2, y2, Const::TILE_SHADOW_CLR[val])

        @window.draw_line(x1, y1, Const::TILE_BRIGHT_CLR[val],
                          x2, y1, Const::TILE_BRIGHT_CLR[val])
        @window.draw_line(x1, y1, Const::TILE_BRIGHT_CLR[val],
                          x1, y2, Const::TILE_BRIGHT_CLR[val])
        @window.draw_line(x1 + 1, y1 + 1, Const::TILE_BRIGHT_CLR[val],
                          x2 - 1, y1 + 1, Const::TILE_BRIGHT_CLR[val])
        @window.draw_line(x1 + 1, y1 + 1, Const::TILE_BRIGHT_CLR[val],
                          x1 + 1, y2 - 1, Const::TILE_BRIGHT_CLR[val])
      end
    end

    # draws board and all blocks on it
    def draw
      draw_background
      @cur_piece.set_on_board
      @board.each_with_index do |row, y|
        row.each_with_index do |val, x|
          draw_block(x, y, val)
        end
      end
      @cur_piece.unset_on_board
    end

    # loads board content from string
    # !!! (expects board to contain only nrs from 0 to 9) !!!
    def from_s!(state)
      @board = state.split('').map { |i| i.to_i }.each_slice(Const::PNR_HOR).to_a
    end

    # returns string of board with current piece
    def get_board_s
      @cur_piece.set_on_board
      s = to_s
      @cur_piece.unset_on_board
      s
    end

    # converts board content to string
    def to_s
      s = ''
      @board.each do |row|
        row.each do |val|
          s << val.to_s
        end
      end
      s
    end
  end
end
