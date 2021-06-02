require 'test_helper'

class VertexTest < ActiveSupport::TestCase
  test 'cannot store vertex without type' do
    vertex = Vertex.new() # creates a vertex of type null
    assert_not vertex.save, 'Saved a vertex without a type'
  end

  test 'cannot save vertex without escape room id' do
    vertex = Vertex.new # creates a vertex of type null
    assert_not vertex.save, 'Saved a vertex without an escape room id'
  end

  test 'cannot save vertex without name' do
  end

  test 'cannot save vertex without pos x' do
  end

  test 'cannot save vertex without pos y' do
  end

  test 'cannot save vertex without width' do
  end

  test 'cannot save vertex without height' do
  end

  test 'cannot save vertex without graphic id' do
  end

  test 'cannot save puzzle without estimated time' do
  end

  test 'cannot save puzzle without description' do

  end

  test 'cannot save clue without clue' do
  end

  test 'cannot save container' do
  end
end
