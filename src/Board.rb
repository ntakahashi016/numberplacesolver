# coding: utf-8
class Board

  def initalize()
    @cells = []
    @blocks = []
    board_col,board_row = 9
    block_col,block_row = 3
    for 0...board_row in y do
      for 0...board_col in x do
        @cells[x,y] = Cell.new
      end
    end
    for 0...board_row in y do
      block = Block.new
      for 0...board_col in x do
        block.add(@cells[x,y])
      end
      @blocks.push(block)
    end
    for 0...board_col in x do
      block = Block.new
      for 0...board_row in y do
        block.add(@cells[x,y])
      end
      @blocks.push(block)
    end
    for 0...(board_row/block_row) in i do
      for 0...(board_col/block_col) in j do
        block = Block.new
        for 0...block_row in k do
          for 0...block_col in l do
            x = (i*block_row) + k
            y = (j*block_col) + l
            block.add(@cells[x,y])
          end
        end
        @blocks.push(block)
      end
    end
  end

  def set_number(x,y,number)
    begin
      @cells[x,y].number = Number.new(number)
    rescue
      raise e
    end
  end

  def get_number(x,y)
    @cells[x,y].number
  end

end
