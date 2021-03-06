# frozen_string_literal: true

require 'test_helper'

class VertexTest < ActiveSupport::TestCase
  test 'cannot store vertex without type' do
    vertex = Vertex.new(type: nil, name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: 1) # creates a vertex of type null
    assert_not vertex.valid?, 'Saved a vertex without a type'
  end

  test 'cannot save a vertex without reference to a room' do
    vertex = Vertex.new(type: 'Keys', name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: nil)
    assert_not vertex.valid?, 'Saved a vertex without a reference to a room'
  end

  test 'cannot save vertex with incorrect escape room id' do
    vertex = Vertex.new(type: 'Keys', name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: 10)
    assert_not vertex.valid?, 'Saved a vertex with incorrect escape room reference'
  end

  test 'cannot save vertex without name' do
    vertex = Vertex.new(type: 'Keys', name: nil, posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a vertex without a name'
  end

  test 'cannot save vertex without pos x' do
    vertex = Vertex.new(type: 'Keys', name: 'tc1', posx: nil, posy: 1.0, width: 1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a vertex without an x coordinate'
  end

  test 'cannot save vertex without pos y' do
    vertex = Vertex.new(type: 'Keys', name: 'tc1', posx: 1.0, posy: nil, width: 1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a vertex without a y coordinate'
  end

  test 'cannot save vertex without width' do
    vertex = Vertex.new(type: 'Keys', name: 'tc1', posx: 1.0, posy: 1.0, width: nil, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a vertex without width'
  end

  test 'cannot save vertex without height' do
    vertex = Vertex.new(type: 'Keys', name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: nil,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a vertex without height'
  end

  test 'cannot save vertex without graphic id' do
    vertex = Vertex.new(type: 'Keys', name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                        graphicid: nil, estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a vertex without height'
  end

  test 'cannot save puzzle without estimated time' do
    vertex = Puzzle.new(name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: nil, description: 'tc1',
                        clue: 'tc1', escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a puzzle without estimate time'
  end

  test 'cannot save puzzle without description' do
    vertex = Puzzle.new(name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: nil,
                        clue: 'tc1', escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a puzzle without description'
  end

  test 'cannot save clue without clue text' do
    vertex = Clue.new(name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                      graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                      clue: nil, escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a clue without clue text'
  end

  test 'negative height vertex is invalid' do
    vertex = Vertex.new(type: Keys, name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: -1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a vertex with a negative height'
  end

  test 'negative width vertex is invalid' do
    vertex = Vertex.new(type: Keys, name: 'tc1', posx: 1.0, posy: 1.0, width: -1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: 'tc1', escape_room_id: 1)
    assert_not vertex.valid?, 'Saved a vertex with a negative height'
  end

  # VALID CASES
  test 'can save valid container' do
    vertex = Container.new(name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                           graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                           clue: nil, escape_room_id: 1)
    assert vertex.valid?
  end

  test 'can save valid clue' do
    vertex = Clue.new(name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                      graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                      clue: 'test clue', escape_room_id: 1)
    assert vertex.valid?
  end

  test 'can save valid puzzle' do
    vertex = Puzzle.new(name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: nil, escape_room_id: 1)
    assert vertex.valid?
  end

  test 'can save valid key' do
    vertex = Keys.new(name: 'tc1', posx: 1.0, posy: 1.0, width: 1.0, height: 1.0,
                        graphicid: 'tc1', estimatedTime: Time.now, description: 'tc1',
                        clue: nil, escape_room_id: 1)
    assert vertex.valid?
  end
end
