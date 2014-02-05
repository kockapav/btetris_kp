#!/usr/bin/env ruby

require 'spec_helper'
require 'gosu'
require "btetris_kp/btetris"

module BTetrisKp
  describe BTetrisWindow do

    it 'can initialize BTetrisWindow' do
      @bt = BTetrisWindow.new
      @bt.should(be_an_instance_of BTetrisWindow)
    end
  end
end
