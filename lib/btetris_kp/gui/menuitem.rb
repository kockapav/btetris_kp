require "btetris_kp/constants"

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

    def update
      if mouse_over?
        @color = Const::MENU_ITEM_MO_CLR
      else
        @color = Const::MENU_ITEM_CLR
      end
    end

    def mouse_over?
      mx = @window.mouse_x
      my = @window.mouse_y
  
      (mx >= @x && my >= @y) &&
      (mx <= @x + @font.text_width(@text)) &&
      (my <= @y + @font.height)
    end

    def clicked
      @callback.call if mouse_over?
    end

    def draw
      @font.draw(@text, @x, @y, 0, 1, 1, @color)
    end
  end
end
