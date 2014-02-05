require 'gosu'
require 'btetris_kp/menu'
require 'btetris_kp/constants'

module BTetrisKp
  # Main class maintaining game window,
  # drawing, updating and reacting to key events
  class BTetrisWindow < Gosu::Window
    attr_accessor :state

    def initialize
      super(Const::GAME_WIDTH, Const::GAME_HEIGHT, false)
      self.caption = Const::GAME_CAPTION
      @state = MenuState.new(self)
    end

    def update
      @state.update
    end

    def draw
      @state.draw
    end

    def button_down(id)
      @state.button_down(id)
    end

    # shows or hides default system cursor depending on state
    def needs_cursor?
      @state.needs_cursor?
    end
  end
end
