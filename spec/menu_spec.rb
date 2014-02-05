#!/usr/bin/env ruby

require 'spec_helper'
require "btetris_kp/btetris"

module BTetrisKp
  describe MenuState do
    before :each do
      @ms = MenuState.new(BTetrisWindow.new)
    end

    it 'can initialize MenuState (window state used for main menu of the game)' do
      @ms.should(be_an_instance_of MenuState)
    end

    it 'can generate background board' do
      @ms.generate_back_board.should(be_an_instance_of Array)
    end

    it 'can generate menu' do
      @ms.generate_menu.should(be_an_instance_of Array)
    end
  end
end
