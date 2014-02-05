#!/usr/bin/env ruby

require 'spec_helper'

module BTetrisKp
  describe GameState do
    before :each do
      @game = GameState.new(BTetrisWindow.new, 50, 50)
    end

    it 'can initialize GameState (window state used for playing game)' do
      @game.should(be_an_instance_of GameState)
    end

    it 'can pause and unpause game' do
      @game.pause!
      @game.paused.should eq true
      @game.pause!
      @game.paused.should eq false
    end

    it 'can tell if game is over' do
      @game.game_over.should eq false
      @game.insert_garbage!(Const::PNR_VER - 1)
      Const::GAME_SPEED.times { @game.update }
      @game.game_over.should eq true
    end
  end
end
