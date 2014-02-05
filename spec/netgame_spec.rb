#!/usr/bin/env ruby

require 'spec_helper'

module BTetrisKp
  describe NetGameState do
    before :each do
      @ng = NetGameState.new(BTetrisWindow.new, nil)
    end

    it 'can initialize NetGameState (window state used for playing net game)' do
      @ng.should(be_an_instance_of NetGameState)
    end
  end
end
