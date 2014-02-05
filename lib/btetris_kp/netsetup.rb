require 'socket'
require "btetris_kp/menu"
require "btetris_kp/netgame"
require "btetris_kp/constants"

module BTetrisKp  
  # class representing a window for creating a game over network (SERVER SIDE)
  class NetSetupState
    def initialize(window)
      @window = window
      @font = Gosu::Font.new(@window, Gosu.default_font_name, 40)
      # load title image and calculate position, size variables
      @title_image = Gosu::Image.new(@window, Const::PATH_IMAGE_TITLE, false)
      @img_size_factor = (@window.width - 50.0) / @title_image.width
      @img_x = (@window.width - @title_image.width * @img_size_factor) / 2
      @img_y = 20
      # setup a server
      @port = 0
      begin
        @port = rand(40_000)
        @server = TCPServer.new @port
      rescue
        retry
      end
      @connected = false
    end

    def update
      if @connected
        @window.state = NetGameState.new(@window, @socket)
      else
        begin
          # tries to accept client connection
          @socket = @server.accept_nonblock
          @socket.sendmsg_nonblock(Const::MSG_WELCOME)
          msg = @socket.recv(1)
          if msg == Const::MSG_WELCOME
            @connected = true
          else
            @socket.close
          end
        rescue
          # no one connected, try again next time
        end
      end
    end

    def draw
      @font.draw(Const::SERVER_WAIT, @window.width / 5,
                 @window.height / 2 - 60, 0)
      @font.draw("#{Const::SERVER_PORT}#{@port}", @window.width / 3.5,
                 @window.height / 2, 0)
      @title_image.draw(@img_x, @img_y, 1, @img_size_factor, @img_size_factor)
    end

    # button handler
    def button_down(id)
      @window.state = MenuState.new(@window) if id == Gosu::KbEscape
    end

    # shows default system cursor
    def needs_cursor?
      true
    end
  end
end
