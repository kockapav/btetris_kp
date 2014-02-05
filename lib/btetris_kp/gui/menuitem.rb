require 'btetris_kp/constants'

module BTetrisKp
  # class representing menu item
  class MenuItem
    def initialize(window, text, id, callback, font, x, y)
      @window = window
      @text = text
      @callback = callback
      @font = font
      @color = Const::MENU_ITEM_CLR
      @x = x
      @y = y + id * (@font.height + 5)
    end

    # updates menu item, changes item color depending on mouse_over?
    def update
      if mouse_over?
        @color = Const::MENU_ITEM_MO_CLR
      else
        @color = Const::MENU_ITEM_CLR
      end
    end

    # returns true if mouse is over menu item
    def mouse_over?
      mx = @window.mouse_x
      my = @window.mouse_y
      (mx >= @x && my >= @y) &&
      (mx <= @x + @font.text_width(@text)) &&
      (my <= @y + @font.height)
    end

    # returns true menu item is clicked (click + mouse_over)
    def clicked
      @callback.call if mouse_over?
    end

    # draws menuitem on window (gosu)
    def draw
      @font.draw(@text, @x, @y, 0, 1, 1, @color)
    end
  end
end
