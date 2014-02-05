require 'gosu'
require 'btetris_kp/menu'
require 'btetris_kp/core/board'
require 'btetris_kp/game'
require 'btetris_kp/constants'

module BTetrisKp
  # class representing net game window state
  # used for playin game over network (no matter if you are client or server)
  class NetGameState
    def initialize(window, socket)
      @window = window
      @socket = socket
      @font = Gosu::Font.new(@window, Gosu.default_font_name, 80)
      @game = GameState.new(@window, 10, 40)
      @o_board = Board.new(@window, 2 * @window.width / 3 - 10, 40)
      @winner = 0
    end

    # sends message to socket
    def send_msg(msg)
      s = ''
      case msg
      when Const::MSG_PAUSE
        s = "#{Const::MSG_PAUSE}"
      when Const::MSG_GAME_OVER
        s = "#{Const::MSG_GAME_OVER}"
      when Const::MSG_BOARD
        s = "#{Const::MSG_BOARD}:#{@game.get_board_s}"
      when Const::MSG_GARBAGE
        s = "#{Const::MSG_GARBAGE}:#{@game.rows_cleared}"
      end
      begin
        @socket.sendmsg_nonblock(s)
      rescue
        # problem s pripojenim -- game over
        @socket.close
        @window.state = MenuState.new(@window)
      end
    end

    # blocking recv for cnt of bytes
    def recv_block(cnt)
      block = nil
      begin
        block = @socket.recv(cnt, Socket::MSG_WAITALL)
      rescue
        # problem s pripojenim -- game over
        @socket.close
        @window.state = MenuState.new(@window)
      end
      block
    end

    # recieves and manages game updates
    def recv_msg(id)
      case id
      when Const::MSG_PAUSE
        @game.pause!
      when Const::MSG_GAME_OVER
        @winner = Const::GAME_WON
      when Const::MSG_BOARD
        recv_block(1)
        board = recv_block(Const::PNR_HOR * Const::PNR_VER)
        @o_board.from_s!(board) unless board.nil?
      when Const::MSG_GARBAGE
        recv_block(1)
        garbage = recv_block(1).to_i
        @game.insert_garbage!(garbage)
      end
    end

    # checks if there is incomming message
    # returns a string with message id, or GOT_NO_MESSAGE
    def check_msg
      begin
        s = @socket.recv_nonblock(1)
        return s
      rescue Errno::EAGAIN
        # zadna zprava, hrajeme dal
      rescue
        # problem s pripojenim -- game over
        @socket.close
        @window.state = MenuState.new(@window)
      rescue
      end
      Const::GOT_NO_MESSAGE
    end

    def update
      if @winner == Const::GAME_ON
        until (m = check_msg) == Const::GOT_NO_MESSAGE
          recv_msg(m)
        end
        unless @game.paused
          @game.update
          send_msg(Const::MSG_BOARD)
          if @game.game_over
            send_msg(Const::MSG_GAME_OVER)
            @winner = Const::GAME_LOST
          end
          if @game.rows_cleared > 0
            send_msg(Const::MSG_GARBAGE)
            @game.rows_cleared = 0
          end
        end
      end
    end

    def draw
      if @winner == Const::GAME_ON
        @game.draw
        @o_board.draw
      elsif @winner == Const::GAME_LOST
        @font.draw(Const::GAME_LOST_CAPTION,
                   @window.width / 2 - 170, @window.height / 2 - 30, 0)
      else
        @font.draw(Const::GAME_WON_CAPTION,
                   @window.width / 2 - 170, @window.height / 2 - 30, 0)
      end
    end

    # button handler
    def button_down(id)
      if @winner == Const::GAME_ON
        case id
        when Gosu::KbP
          send_msg(Const::MSG_PAUSE)
          @game.pause!
        when Gosu::KbEscape
          send_msg(Const::MSG_GAME_OVER)
          sleep(0.2)
          @socket.close
          @window.state = MenuState.new(@window)
        else
          @game.button_down(id)
        end
      else
        if id == Gosu::KbEscape
          @socket.close
          @window.state = MenuState.new(@window)
        end
      end
    end

    # hides default system cursor
    def needs_cursor?
      true
    end
  end
end
