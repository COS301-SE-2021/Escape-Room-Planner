class Vertex

  id
  name
  graphicID
  x
  y
  width
  height

  def initialize(id,name,graphicID,x,y,width,height)
    this.id=id
    this.name=name
    this.graphicID=graphicID
    this.x = x
    this.y = y
    this.width = width
    this.height = height
  end

  def setID(id)
    @id=id
  end

  def getID
    return id
  end

  def setName(name)
    @name=name
  end

  def getName
    return name
  end

  def setgraphicID(graphicID)
    @graphicID=graphicID
  end

  def getgraphicID
    return graphicID
  end

  def setPosition(x,y)
    @x = x
    @y = y
  end

  def getPosition
    return x,y
  end

  def setDimension(width,height)
    @width = width
    @height = height
  end

  def getDimensions
    return width,height
  end

end