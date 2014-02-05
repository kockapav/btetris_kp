#!/usr/bin/env ruby

require 'spec_helper'
require "btetris_kp/constants"

module BTetrisKp
  describe MenuItem do
    before :each do
      @window = Gosu::Window.new(800, 600, false)
      font = Gosu::Font.new(@window, Gosu.default_font_name, 10)
      @set = false
      @mi = MenuItem.new(@window, 'TEST MENU', 0, lambda { @set = true }, font,  50, 50)
    end

    it 'can initialize MenuItem' do
      @mi.should(be_an_instance_of MenuItem)
    end

    it 'can tell if mouse is over' do
       @window.mouse_x, @window.mouse_y = 0, 0
       @mi.mouse_over?.should eq false
       @window.mouse_x, @window.mouse_y = 0, 100
       @mi.mouse_over?.should eq false
       @window.mouse_x, @window.mouse_y = 400, 0
       @mi.mouse_over?.should eq false
       @window.mouse_x, @window.mouse_y = 400, 100
       @mi.mouse_over?.should eq false
       @window.mouse_x, @window.mouse_y = 55, 55
       @mi.mouse_over?.should eq true
    end

    it 'can call procedure when clicked' do
       @window.mouse_x, @window.mouse_y = 55, 55
       @mi.clicked
       @set.should eq true
    end
    
  end
end
