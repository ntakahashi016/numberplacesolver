# coding: utf-8
class Block

  def initialize()
    @cells = []
  end

  def add(cell)
    if cell.class == Cell
      @cells.push = cell
    else
      raise e
    end
  end

  def [](index)
    @cells[index]
  end
end
