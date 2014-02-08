require 'btetris_kp/menu'
require 'btetris_kp/core/board'
require 'btetris_kp/constants'

module BTetrisKp
  # class representing game window state
  class GameState
    attr_reader :game_over, :paused
    attr_accessor :rows_cleared

    def initialize(window, x, y)
      @window = window
      @font = Gosu::Font.new(@window, Gosu.default_font_name, Const::FONT_BIG_SIZE)
      @board = Board.new(@window, x, y)
      @paused, @game_over = false, false
      # press time, set 0 when left, right or down key is pressed
      # used for smoother controls in update method
      @counter, @press_time, @rows_cleared = 0, 0, 0
      initialize_sounds
    end

    # initializes ingame sounds
    def initialize_sounds
      @drop_snd = Gosu::Sample.new(@window, Const::PATH_SND_DROP)
      @clear_snd = Gosu::Sample.new(@window, Const::PATH_SND_POP)
      @rotate_snd = Gosu::Sample.new(@window, Const::PATH_SND_ROTATE)
    end

    # inserts garbage in board depending on count of cleared rows
    def insert_garbage!(cnt)
      @board.insert_garbage!(cnt)
    end

    # returns game board in a string (current piece included)
    def get_board_s
      @board.get_board_s
    end

    # switches pause boolean
    def pause!
      @paused = !@paused
    end

    # updates game
    def update
      unless @paused || @game_over
        @press_time += 1
        @counter += 1

        if @press_time % Const::DROP_SPEED == 0
          # check if KbDown is pressed, move piece down in faster interval
          @board.piece_down! if @window.button_down?(Gosu::KbDown)
        end
        if @press_time % Const::TURN_SPEED == 0
          # check if KbLeft is pressed, move piece left in faster interval
          @board.piece_left! if @window.button_down?(Gosu::KbLeft)
          # check if KbRight is pressed, move piece right in faster interval
          @board.piece_right! if @window.button_down?(Gosu::KbRight)
        end

        # checks if it's time for next step in game
        if @counter % Const::GAME_SPEED == 0
          @rows_cleared = @board.next_step!
          @clear_snd.play if @rows_cleared > 0
          # checks if it's game over
          @game_over = @board.game_over?
        end
      end
    end

    # draws board and texts if paused or game over
    def draw
      @board.draw
      x = @window.width / 2
      y = @window.height / 2 - 30
      @font.draw(Const::PAUSE_CAPTION, x - 130, y, 0) if @paused
      @font.draw(Const::GAME_OVER_CAPTION, x - 170, y, 0) if @game_over
    end

    # button handler
    def button_down(id)
      if @game_over || @paused
        pause! if @paused && id == Gosu::KbP
        if @game_over && id == Gosu::KbEscape
          @window.state = MenuState.new(@window)
        end
      else
        # handling specific events
        case id
        when Gosu::KbEscape
          @window.state = MenuState.new(@window)
        when Gosu::KbP
          pause!
        when Gosu::KbLeft
          @board.piece_left!
          @press_time = 0
        when Gosu::KbRight
          @board.piece_right!
          @press_time = 0
        when Gosu::KbDown
          @board.piece_down!
          @press_time = 0
        when Gosu::KbUp
          @rotate_snd.play if @board.piece_rotate!
        when Gosu::KbSpace
          @board.piece_drop!
          @drop_snd.play
          @counter = Const::GAME_SPEED - 10
        end
      end
    end

    # hides default system cursor
    def needs_cursor?
      true
    end
  end
end
