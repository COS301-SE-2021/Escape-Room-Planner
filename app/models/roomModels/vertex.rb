class Vertex

  
  def initialize(id, name, graphicid, x, y, width, height)
    @id = id
    @name = name
    @graphicid = graphicid
    @xpos = x
    @ypos = y
    @width = width
    @height = height
  end

  def setid(id)
    @id = id
  end

  def getid
    @id
  end

  def setname(name)
    @name = name
  end

  def getname
    @name
  end

  def setgraphicid(graphicid)
    @graphicid = graphicid
  end

  def getgraphicid
     @graphicid
  end

  def setposition(x, y)
    @xpos = x
    @ypos = y
  end

  def getposition
    [@xpos, @ypos]
  end

  def setdimension(width, height)
    @width = width
    @height = height
  end

  def getdimensions
    [@width, @height]
  end

end