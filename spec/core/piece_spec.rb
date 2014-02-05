#!/usr/bin/env ruby

require "btetris_kp/core/piece"
require "btetris_kp/core/board"
require 'spec_helper'

module BTetrisKp
  describe Piece do
    before :each do
      @board = Board.new(Gosu::Window.new(800, 600, false), 20, 20)
    end
  
    it 'can initialize Piece' do
      pi = Piece.new(@board.board, 10, 15, 0).should(be_an_instance_of Piece)
    end

    it 'can place any type of piece on empty board' do
      (0...Const::TILES.size).each_with_index do |tile, index|
        pi = Piece.new(@board.board, 0, 0, index)
        pi.can_be_set?.should eq true
      end
    end

    it 'can rotate any type of piece to both directions' do
      (0...Const::TILES.size).each_with_index do |tile, index|
        pi = Piece.new(@board.board, 4, 4, index)
        pi.can_be_set?.should eq true
        3.times do
          pi.rotate_right!
          pi.can_be_set?.should eq true
        end
        3.times do
          pi.rotate_left!
          pi.can_be_set?.should eq true
        end
      end
    end

    it 'can tell if piece can be placed on board or not' do
      pi = Piece.new(@board.board, 0, 0, 0)
      pi.can_be_set?.should eq true
      @board.board[0][0] = 1
      pi.can_be_set?.should eq false
    end

    it 'can move piece left' do
      pi = Piece.new(@board.board, 4, 4, 0)
      pi.move_left!
      pi.can_be_set?.should eq true
    end

    it 'can move piece right' do
      pi = Piece.new(@board.board, 4, 4, 0)
      pi.move_right!
      pi.can_be_set?.should eq true
    end

    it 'can move piece up' do
      pi = Piece.new(@board.board, 4, 4, 0)
      pi.move_up!
      pi.can_be_set?.should eq true
    end

    it 'can move piece down' do
      pi = Piece.new(@board.board, 4, 4, 0)
      pi.move_down!
      pi.can_be_set?.should eq true
    end

    it 'can not place piece on full board' do
      @board.board.each_with_index do |row, x|
        row.each_with_index do |val, y|
          @board.board[x][y] = 1
        end
      end
      pi = Piece.new(@board.board, 4, 4, 0)
      pi.can_be_set?.should eq false
    end

    it 'can not place piece after moving on filled block' do
      @board.board[0][0] = 1
      pi = Piece.new(@board.board, 0, 1, 0)
      pi.can_be_set?.should eq true
      pi.move_left!
      pi.can_be_set?.should eq false
    end

    it 'can not leave board borders when moving' do
      pi = Piece.new(@board.board, 0, 0, 0)
      pi.can_be_set?.should eq true
      pi.move_left!
      pi.can_be_set?.should eq false
      pi.move_right!
      pi.move_up!
      pi.can_be_set?.should eq false
    end

    it 'can be set on board' do
      pi = Piece.new(@board.board, 0, 0, 0)
      pi.can_be_set?.should eq true
      @board.board[0][0].should eq 0
      pi.set_on_board
      @board.board[0][0].should_not eq 0
    end

    it 'can be unset from board' do
      pi = Piece.new(@board.board, 0, 0, 0)
      pi.set_on_board
      @board.board[0][0].should_not eq 0
      pi.unset_on_board
      @board.board[0][0].should eq 0
    end
  end
end
