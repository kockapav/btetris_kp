#!/usr/bin/env ruby

require "btetris_kp/core/piece"
require "btetris_kp/core/board"
require 'spec_helper'

module BTetrisKp
  describe Board do
    before :each do
      @board = Board.new(BTetrisWindow.new, 20, 20)
    end

    it 'can initialize Board' do
      @board.should(be_an_instance_of Board)
    end

    it 'can convert board to string' do
      str = @board.to_s
      str.size.should eq Const::PNR_VER * Const::PNR_HOR
      str.each_char { |val| val.should eq '0' }
    end

    it 'can convert string to board' do
      str = @board.to_s
      str[0] = '1'
      str[Const::PNR_VER * Const::PNR_HOR - 1] = '2'
      @board.from_s!(str)
      @board.board[0][0].should eq 1
      @board.board[Const::PNR_VER - 1][Const::PNR_HOR - 1].should eq 2
    end

    it 'can tell if game is over' do
      @board.game_over?.should eq false
      @board.board[0].each_with_index { |val, y| @board.board[0][y] = 1 }
      @board.game_over?.should eq true
    end

    it 'can clear full rows' do
      @board.board[0].each_with_index { |val, y| @board.board[0][y] = 1 }
      @board.board[3].each_with_index { |val, y| @board.board[3][y] = 1 }
      cnt = @board.clear_rows!
      cnt.should eq 2
      @board.board[0][0].should eq 0
      @board.board[3][0].should eq 0
    end

    it 'can move other rows correctly when clearing rows' do
      @board.board[2].each_with_index { |val, y| @board.board[2][y] = 1 }
      @board.board[0][0] = 1
      @board.board[1][1] = 1
      cnt = @board.clear_rows!
      cnt.should eq 1
      @board.board[1][0].should eq 1
      @board.board[2][1].should eq 1
    end

    it 'can insert garbage rows at the bottom of the board' do
      @board.insert_garbage!(2)
      full = 0
      empty = 0
      @board.board[Const::PNR_VER - 1].each do |val|
        if val == 0
          empty += 1
        else
          full += 1
        end
      end
      empty.should_not eq 0
      full.should_not eq 0
    end

    it 'can drop piece to the bottom of the board' do
      @board.cur_piece = Piece.new(@board.board, 0, 0, 0)
      @board.piece_drop!
      @board.cur_piece.set_on_board
      @board.board[Const::PNR_VER - 1][0].should_not eq 0
    end

    it 'can tell if piece is stuck (cant move further down)' do
      @board.cur_piece = Piece.new(@board.board, 0, 0, 0)
      @board.piece_stuck?.should eq false
      @board.piece_drop!
      @board.piece_stuck?.should eq true

      @board.cur_piece = Piece.new(@board.board, 0, 0, 0)
      @board.board[2][0] = 1
      @board.piece_stuck?.should eq true
    end
  end
end
