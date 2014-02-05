require 'gosu'
require 'socket'
require "btetris_kp/netgame"
require "btetris_kp/gui/textfield"
require "btetris_kp/constants"

module BTetrisKp
  # class representing a window for joining a game over network (CLIENT SIDE)
  class NetJoinState
    def initialize(window)
      @window = window
      @font = Gosu::Font.new(@window, Gosu.default_font_name, 40)
      @connecting = false
      # load title image and calculate position, size variables
      @title_image = Gosu::Image.new(@window, Const::PATH_IMAGE_TITLE, false)
      @img_size_factor = (@window.width - 50.0) / @title_image.width
      @img_x = (@window.width - @title_image.width * @img_size_factor) / 2
      @img_y = 20
      # initializes position for texts and textfields
      @text_x = @window.width / 3 + 10
      @text_y = @window.height / 3
      @ip_x = @text_x - @font.text_width(Const::IP_CAPTION) - 15
      @port_x = @text_x - @font.text_width(Const::PORT_CAPTION) - 15
      # initializes text fields for reading ip and port
      @text_fields = []
      @text_fields << TextField.new(@window, @font, @text_x,
                                    @text_y, Const::DEF_IP, /[^0-9.]/,
                                    @font.text_width('000.000.000.000'), 15)
      @text_fields << TextField.new(@window, @font, @text_x,
                                    @text_y + @font.height + 10,
                                    Const::DEF_PORT, /[^0-9]/,
                                    @font.text_width('00000'), 5)
      @socket = nil
    end

    def update
      @text_fields.each { |t| t.update }
      if @connecting
        if @socket.nil?
          # trying to connect
          begin
            @socket = TCPSocket.new(@text_fields[0].text, @text_fields[1].text)
            @socket.sendmsg_nonblock(Const::MSG_WELCOME)
            msg = @socket.recv(1)
            unless msg == Const::MSG_WELCOME
              @socket.close
              @socket = nil
            end
          rescue
            # error while connecting
          end
        else
          # socket created and connected, start net game
          @window.text_input = nil
          @window.state = NetGameState.new(@window, @socket)
        end
      end
    end

    def draw
      @text_fields.each { |t| t.draw }
      @font.draw(Const::IP_CAPTION, @ip_x,
                 @text_y, 0)
      @font.draw(Const::PORT_CAPTION, @port_x,
                 @text_y + @font.height + 10, 0)
      @font.draw(Const::CONNECTING, @text_x,
                 @text_y + 3 * (@font.height + 10), 0) if @connecting
      @title_image.draw(@img_x, @img_y, 1, @img_size_factor, @img_size_factor)
    end

    # button handler
    def button_down(id)
      case id
      when Gosu::KbEscape
        if @connecting
          @connecting = false
        else
          @window.text_input = nil
          @window.state = MenuState.new(@window)
        end
      when Gosu::KbReturn
        @connecting = true unless @connecting
      when Gosu::MsLeft
        @window.text_input = @text_fields.find { |tf| tf.mouse_over?(@window.mouse_x, @window.mouse_y) }
        @window.text_input.move_caret(@window.mouse_x) unless @window.text_input.nil?
      end
    end

    # shows default system cursor
    def needs_cursor?
      true
    end
  end
end
