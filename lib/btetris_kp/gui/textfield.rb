require 'gosu'
require 'btetris_kp/constants'

module BTetrisKp
  # class representing input box for IP adress / port / text
  class TextField < Gosu::TextInput
    attr_reader :x, :y

    def initialize(window, font, x, y, text, filter, width, maxlen)
      super()
      @window = window
      @font = font
      @x = x
      @y = y
      @width = width
      @filter = filter
      @maxlen = maxlen
      self.text = text
    end

    # filters text of characters specified in regexp
    def filter(text)
      text.upcase.gsub(@filter, '')
    end

    # updates textfield, limits length of text to @maxlen
    def update
      self.text = text.slice(0...@maxlen) if text.size > @maxlen
    end

    # draws textfield on window (gosu)
    def draw
      @window.draw_line(@x - Const::BORDER_GAP, @y + @font.height, Const::CARET_CLR,
                        @x + @width + 2 * Const::BORDER_GAP, @y + @font.height, Const::CARET_CLR)
      unless text.nil?
        # draws the caret if textfield is selected
        pos_x = @x + @font.text_width(text[0...caret_pos])
        if @window.text_input == self
          @window.draw_line(pos_x, @y, Const::CARET_CLR,
                            pos_x, @y + @font.height, Const::CARET_CLR, 0)
        end

        @font.draw(text, @x, @y, 0)
      end
    end

    # returns true if mouse is over textfield
    def mouse_over?(mouse_x, mouse_y)
      mouse_x >= x - Const::BORDER_GAP &&
      mouse_x <= x + @width + Const::BORDER_GAP &&
      mouse_y >= y - Const::BORDER_GAP &&
      mouse_y <= y + @font.height + Const::BORDER_GAP
    end

    # moves the caret to the position specified by mouse
    def move_caret(mouse_x)
      1.upto(text.length) do |i|
        if mouse_x < x + @font.text_width(text[0...i])
          self.caret_pos = self.selection_start = i - 1
          return
        end
      end
      self.caret_pos = self.selection_start = text.length
    end
  end
end
