class Vertex

  
  def initialize(id, name, graphicID, x, y, width, height)
    @id = id
    @name = name
    @graphicID = graphicID
    @x = x
    @y = y
    @width = width
    @height = height
  end

  def setID(id)
    @id = id
  end

  def getID
    @id
  end

  def setName(name)
    @name = name
  end

  def getName
    @name
  end

  def setgraphicID(graphicID)
    @graphicID = graphicID
  end

  def getgraphicID
     @graphicID
  end

  def setPosition(x, y)
    @x = x
    @y = y
  end

  def getPosition
    [@x, @y]
  end

  def setDimension(width, height)
    @width = width
    @height = height
  end

  def getDimensions
    [@width, @height]
  end

end