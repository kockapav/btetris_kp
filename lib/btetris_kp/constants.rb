module BTetrisKp
  # module with constants, colors, tile shapes
  module Const
    # Game window Const
    GAME_WIDTH = 800
    GAME_HEIGHT = 600
    GAME_WIN_GAP = (GAME_WIDTH * 0.075).to_i
    GAME_CAPTION = 'Battle tetris'
    PAUSE_CAPTION = 'Paused!'
    GAME_OVER_CAPTION = 'Game over!'
    GAME_WON_CAPTION = 'You WIN!'
    GAME_LOST_CAPTION = 'You LOSE!'

    # Font constants
    FONT_GAP = 5
    FONT_SMALL_SIZE = (GAME_WIDTH * 0.035).to_i
    FONT_MED_SIZE = (GAME_WIDTH * 0.05).to_i
    FONT_BIG_SIZE = (GAME_WIDTH * 0.1).to_i

    # File paths
    PATH = File.dirname(File.expand_path(__FILE__))
    PATH_IMAGE_TITLE = File.join(PATH, '../../media/title.png')
    PATH_SND_DROP = File.join(PATH, '../../media/drop.ogg')
    PATH_SND_POP = File.join(PATH, '../../media/pop.ogg')
    PATH_SND_ROTATE = File.join(PATH, '../../media/rotate.ogg')

    # Menu item captions
    MENU_NEW = 'New game'
    MENU_CREATE = 'Create net game'
    MENU_JOIN = 'Join net game'
    MENU_QUIT = 'Quit'

    # Net captions
    IP_CAPTION = 'IP:'
    PORT_CAPTION = 'Port:'
    CONNECTING = 'Connecting...'
    DEF_IP = '127.0.0.1'
    DEF_PORT = ''
    SERVER_WAIT = 'Waiting for client to connect...'
    SERVER_PORT = 'Used port: '

    # Game Const
    GAME_SPEED = 60
    DROP_SPEED = 5
    TURN_SPEED = 8
    GAME_WON = 1
    GAME_LOST = -1
    GAME_ON = 0

    # Size of board in pieces
    PNR_HOR = 10
    PNR_VER = 20

    # TextInput Const
    BORDER_GAP = 5

    # Network Const
    GOT_NO_MESSAGE = '0'
    MSG_PAUSE = '1'
    MSG_GAME_OVER = '2'
    MSG_BOARD = '3'
    MSG_GARBAGE = '4'
    MSG_WELCOME = '5'

    # Color Const
    BOARD_BACK_CLR = Gosu::Color.new(0xFF101010)
    BOARD_CLR = Gosu::Color.new(0xFFB8B8B8)
    CARET_CLR = Gosu::Color.new(0xFFFFFFFF)
    MENU_ITEM_CLR = Gosu::Color.new(0xFFFFFFFF)
    MENU_ITEM_MO_CLR = Gosu::Color.new(0xFFCCFF33)
    # NR of colors shouldnt be higher then 9, (board#from_s)
    TILE_COLORS_NR = 8
    TILE_COLORS = [0,
                   Gosu::Color.new(0xFFC80000),
                   Gosu::Color.new(0xFF0000CC),
                   Gosu::Color.new(0xFF990066),
                   Gosu::Color.new(0xFF99FF00),
                   Gosu::Color.new(0xFFCCFF00),
                   Gosu::Color.new(0xFFFF6600),
                   Gosu::Color.new(0xFF00FF99),
                   Gosu::Color.new(0xFFFFFF00)]
    TILE_BRIGHT_CLR = [0,
                       Gosu::Color.new(0xFFE00000),
                       Gosu::Color.new(0xFF0033CC),
                       Gosu::Color.new(0xFF990099),
                       Gosu::Color.new(0xFF99FF33),
                       Gosu::Color.new(0xFFCCFF33),
                       Gosu::Color.new(0xFFFF6633),
                       Gosu::Color.new(0xFF00FFCC),
                       Gosu::Color.new(0xFFFFFF33)]
    TILE_SHADOW_CLR = [0,
                       Gosu::Color.new(0xFF700000),
                       Gosu::Color.new(0xFF000099),
                       Gosu::Color.new(0xFF990033),
                       Gosu::Color.new(0xFF99CC00),
                       Gosu::Color.new(0xFFCCCC00),
                       Gosu::Color.new(0xFFFF3300),
                       Gosu::Color.new(0xFF00CC99),
                       Gosu::Color.new(0xFFFFCC00)]

    TILES =
    [
      [
        [
          [1, 1],
          [1, 1]
        ]
      ],
      [
        [
          [1, 1, 1],
          [0, 1, 0]
        ],
        [
          [0, 1],
          [1, 1],
          [0, 1]
        ],
        [
          [0, 1, 0],
          [1, 1, 1]
        ],
        [
          [1, 0],
          [1, 1],
          [1, 0]
        ]
      ],
      [
        [
          [1, 1, 0],
          [0, 1, 1]
        ],
        [
          [0, 1],
          [1, 1],
          [1, 0]
        ]
      ],
      [
        [
          [0, 1, 1],
          [1, 1, 0]
        ],
        [
          [1, 0],
          [1, 1],
          [0, 1]
        ]
      ],
      [
        [
          [1, 1, 1, 1]
        ],
        [
          [1],
          [1],
          [1],
          [1]
        ]
      ],
      [
        [
          [1, 0, 0],
          [1, 1, 1]
        ],
        [
          [1, 1],
          [1, 0],
          [1, 0]
        ],
        [
          [1, 1, 1],
          [0, 0, 1]
        ],
        [
          [0, 1],
          [0, 1],
          [1, 1]
        ]
      ],
      [
        [
          [0, 0, 1],
          [1, 1, 1]
        ],
        [
          [1, 0],
          [1, 0],
          [1, 1]
        ],
        [
          [1, 1, 1],
          [1, 0, 0]
        ],
        [
          [1, 1],
          [0, 1],
          [0, 1]
        ]
      ]
    ]
  end
end
