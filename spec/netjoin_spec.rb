#!/usr/bin/env ruby

require 'spec_helper'

module BTetrisKp
  describe NetJoinState do
    before :each do
      @nj = NetJoinState.new(BTetrisWindow.new)
    end

    it 'can initialize NetJoinState (window state used for joining net game)' do
      @nj.should(be_an_instance_of NetJoinState)
    end
  end
end
