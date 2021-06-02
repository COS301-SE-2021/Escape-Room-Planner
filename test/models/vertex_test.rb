require 'test_helper'

class VertexTest < ActiveSupport::TestCase
  test 'cannot save a vertex of type Vertex' do
    vertex = Vertex.new
    assert_not vertex.save, 'Saved a vertex'
  end

  test 'cannot save vertex without escape room id'do
    vertex = Vertex.new #need to make this of some type that is not Vertex
    assert_not vertex.save, 'Saved vertex witohut foreign key'
  end

  test 'cannot save vertex without name' do
    vertex = Vertex.new
  end
  
  test 'cannot save vertex without pos x' do

  end

  test 'cannot save vertex without pos y' do

  end

  test 'cannot save vertex without width' do

  end

  test 'cannot save vertex without height' do

  end
end
