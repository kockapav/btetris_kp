#!/usr/bin/env ruby

require 'spec_helper'
require "btetris_kp/gui/textfield"

module BTetrisKp
  describe TextField do
    before :each do
      window = Gosu::Window.new(800, 600, false)
      font = Gosu::Font.new(window, Gosu.default_font_name, 10)
      @tf = TextField.new(window, font, 50, 50, '12345',  /[^0-9]/, 100, 9)
    end

    it 'can initialize TextField' do
      @tf.should(be_an_instance_of TextField)
    end

    it 'can filter text' do
      @tf.filter('ah0j').should eq '0'
    end

    it 'can tell if mouse is over' do
       @tf.mouse_over?(0,0).should eq false
       @tf.mouse_over?(0,100).should eq false
       @tf.mouse_over?(300,0).should eq false
       @tf.mouse_over?(300,100).should eq false
       @tf.mouse_over?(55,55).should eq true
    end

    it 'can set caret position depending on mouse click' do
       @tf.move_caret(50)
       @tf.caret_pos.should eq 0
    end
  end
end
