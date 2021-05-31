class Vertex

  String id
  String name
  String graphicID
  int x
  int y
  int width
  int height

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
    this.id=id
  end

  def getID
    return id
  end

  def setName(name)
    this.name=name
  end

  def getName
    return name
  end

  def setgraphicID(graphicID)
    this.graphicID=graphicID
  end

  def getgraphicID
    return graphicID
  end

  def setPosition(x,y)
    this.x = x
    this.y = y
  end

  def getPosition
    return x,y
  end

  def setDimension(width,height)
    this.width = width
    this.height = height
  end

  def getDimensions
    return width,height
  end

end