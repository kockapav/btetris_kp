#!/usr/bin/env ruby

require 'spec_helper'

module BTetrisKp
  describe NetSetupState do
    before :each do
      @window = Gosu::Window.new(800, 600, false)
      @nj = NetSetupState.new(@window)
    end

    it 'can initialize NetSetupState (window state used for creating net game)' do
      @nj.should(be_an_instance_of NetSetupState)
    end
  end
end
