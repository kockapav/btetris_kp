require 'gosu'
require 'btetris_kp/game'
require 'btetris_kp/core/board'
require 'btetris_kp/gui/menuitem'
require 'btetris_kp/netsetup'
require 'btetris_kp/netjoin'
require 'btetris_kp/constants'

module BTetrisKp
  # class representing main menu window state
  class MenuState
    def initialize(window)
      @window = window
      @font = Gosu::Font.new(@window, Gosu.default_font_name, 30)
      # load title image and calculate position, size variables
      p 
      @title_image = Gosu::Image.new(@window, Const::PATH_IMAGE_TITLE, false)
      @img_size_factor = (@window.width - 50.0) / @title_image.width
      @img_x = (@window.width - @title_image.width * @img_size_factor) / 2
      @img_y = 20
      # calculate menu position
      @x = @window.width / 3 + 30
      @y = @title_image.height
      generate_back_board
      generate_menu
    end

    # generates background board
    def generate_back_board
      @board = Board.new(@window, @window.width / 3, 40)
      nice_board = Array.new(Const::PNR_VER) { Array.new(Const::PNR_HOR, 0) }
      nice_board.each_with_index do |row, x|
        if x > Const::PNR_VER / 2
          row.each_with_index do |val, y|
            nice_board[x][y] = rand(Const::TILE_COLORS_NR + 1)
          end
        end
      end
      @board.board = nice_board
    end

    # generates menu, menu items and callback procedures for menu items
    def generate_menu
      @items = []
      n_g = proc { @window.state = GameState.new(@window, @window.width / 3, 40) }
      cr_n = proc { @window.state = NetSetupState.new(@window) }
      j_n = proc { @window.state = NetJoinState.new(@window) }
      exit = proc { @window.close }
      @items << MenuItem.new(@window, Const::MENU_NEW, 0, n_g, @font, @x, @y)
      @items << MenuItem.new(@window, Const::MENU_CREATE, 1, cr_n, @font, @x, @y)
      @items << MenuItem.new(@window, Const::MENU_JOIN, 2, j_n, @font, @x, @y)
      @items << MenuItem.new(@window, Const::MENU_QUIT, 3, exit, @font, @x, @y)
    end

    def update
      @items.each { |i| i.update }
    end

    def draw
      @board.draw
      @items.each { |i| i.draw }
      @title_image.draw(@img_x, @img_y, 1, @img_size_factor, @img_size_factor)
    end

    # button handler
    def button_down(id)
      case id
      when Gosu::KbEscape
        @window.close
      when Gosu::MsLeft then
        @items.each { |i| i.clicked }
      end
    end

    # shows default system cursor
    def needs_cursor?
      true
    end
  end
end
