require 'btetris_kp/constants'

module BTetrisKp
  # class representing actual piece in game
  class Piece
    def initialize(board, posx, posy, piece_nr)
      @board = board
      @posx = posx
      @posy = posy
      @nr = piece_nr
      @rot = 0
      @color = rand(Const::TILE_COLORS_NR) + 1
      @piece = Const::TILES[@nr][@rot]
    end

    # moves piece one block to the left
    def move_left!
      @posy -= 1
    end

    # moves piece one block to the right
    def move_right!
      @posy += 1
    end

    # moves piece one block up
    def move_up!
      @posx -= 1
    end

    # moves piece one block down
    def move_down!
      @posx += 1
    end

    # rotates piece left
    def rotate_left!
      @rot = (@rot - 1) % Const::TILES[@nr].size
      @piece = Const::TILES[@nr][@rot]
    end

    # rotates piece right
    def rotate_right!
      @rot = (@rot + 1) % Const::TILES[@nr].size
      @piece = Const::TILES[@nr][@rot]
    end

    # returns true if there is no collision with peace on board
    def can_be_set?
      return false if @posx < 0 || @posy < 0
      @piece.each_with_index do |row, x|
        row.each_with_index do |val, y|
          return false if @posx + x > Const::PNR_VER - 1 ||
                          @posy + y > Const::PNR_HOR - 1
          return false if @board[@posx + x][@posy + y] > 0 && val > 0
        end
      end
      true
    end

    # sets peace on board
    def set_on_board
      @piece.each_with_index do |row, x|
        row.each_with_index do |val, y|
          @board[@posx + x][@posy + y] = @color if val == 1
        end
      end
    end

    # unsets peace from board
    def unset_on_board
      @piece.each_with_index do |row, x|
        row.each_with_index do |val, y|
          @board[@posx + x][@posy + y] = 0 if val == 1
        end
      end
    end
  end
end
