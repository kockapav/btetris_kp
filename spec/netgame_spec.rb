#!/usr/bin/env ruby

require 'spec_helper'

module BTetrisKp
  # class used for testing socket connection messages
  class TestSocket
    attr_accessor :msg

    def initialize(msg)
      @msg = msg
    end

    def sendmsg_nonblock(s)
      @msg = s
    end

    def recv_nonblock(cnt)
      @msg
    end
  end

  describe NetGameState do
    it 'can initialize NetGameState (window state used for playing net game)' do
      ng = NetGameState.new(BTetrisWindow.new, nil)
      ng.should(be_an_instance_of NetGameState)
    end

    it 'can send pause message' do
      s = TestSocket.new('')
      ng = NetGameState.new(BTetrisWindow.new, s)
      ng.send_msg(Const::MSG_PAUSE)
      s.msg.should eq Const::MSG_PAUSE
    end

    it 'can send game over message' do
      s = TestSocket.new('')
      ng = NetGameState.new(BTetrisWindow.new, s)
      ng.send_msg(Const::MSG_GAME_OVER)
      s.msg.should eq Const::MSG_GAME_OVER
    end

    it 'can send message with board update' do
      s = TestSocket.new('')
      ng = NetGameState.new(BTetrisWindow.new, s)
      ng.send_msg(Const::MSG_BOARD)
      m = s.msg.split(":")
      m[0].should eq Const::MSG_BOARD
      b = Board.new(BTetrisWindow.new, 20, 20)
      m[1].size.should eq Const::PNR_VER * Const::PNR_HOR
      (m[1] =~ /^[0-9]+$/).should eq 0
    end

    it 'can send garbage message' do
      s = TestSocket.new('')
      ng = NetGameState.new(BTetrisWindow.new, s)
      ng.send_msg(Const::MSG_GARBAGE)
      m = s.msg.split(":")
      m[0].should eq Const::MSG_GARBAGE
      m[1].to_i.should eq 0
    end

    it 'can correctly interpret incoming message type' do
      s = TestSocket.new(Const::MSG_PAUSE)
      ng = NetGameState.new(BTetrisWindow.new, s)
      ng.check_msg.should eq Const::MSG_PAUSE
      s.msg = Const::MSG_GAME_OVER
      ng.check_msg.should eq Const::MSG_GAME_OVER
      s.msg = Const::MSG_BOARD
      ng.check_msg.should eq Const::MSG_BOARD
      s.msg = Const::MSG_GARBAGE
      ng.check_msg.should eq Const::MSG_GARBAGE
    end
  end
end
