# coding: utf-8

require './Factory'
require './Cell'
require './Block'
require './Board'

class NxNBoardFactory < Factory
  def generate(n)
    board = Board.new(n)
    cells = []
    blocks = []
    block_size = Integer.sqrt(n)
    unless block_size ** 2 == n
      raise "Class:#{self.class.name}##{__method__} 指定したサイズ(#{n})では盤面を生成できません。平方根が整数となる数値を使用してください"
    end

    # Board上の全Cellを生成
    for y in 0...n do
      cells[y] = []
      for x in 0...n do
        cells[y][x] = Cell.new(x,y)
      end
    end
    # 横一列のBlockにCellを登録
    for y in 0...n do
      block = Block.new(n)
      for x in  0...n do
        block.add(cells[y][x])          rescue puts "WARNIG:" + $!.message
        cells[y][x].add_observer(block) rescue puts "WARNIG:" + $!.message
      end
      blocks.push(block)
    end
    # 縦一列のBlockにCellを登録
    for x in 0...n do
      block = Block.new(n)
      for y in 0...n do
        block.add(cells[y][x])          rescue puts "WARNIG:" + $!.message
        cells[y][x].add_observer(block) rescue puts "WARNIG:" + $!.message
      end
      blocks.push(block)
    end
    # NxN領域にCellを登録
    for i in 0...(n/block_size) do
      for j in 0...(n/block_size) do
        block = Block.new(n)
        for k in 0...block_size do
          for l in 0...block_size do
            y = (i*block_size) + k
            x = (j*block_size) + l
            block.add(cells[y][x])          rescue puts "WARNIG:" + $!.message
            cells[y][x].add_observer(block) rescue puts "WARNIG:" + $!.message
          end
        end
        blocks.push(block)
      end
    end

    board.set_cells(cells)
    board.set_blocks(blocks)
    board
  end
end

class NxNDiagonalBoardFactory < NxNBoardFactory
  def generate(n)
    board = super(n)
    cells = board.get_cells
    blocks = board.get_blocks
    block = Block.new(n)
    (0...n).to_a.zip((0...n).to_a).each do |x,y|
      block.add(cells[y][x])          rescue puts "WARNIG:" + $!.message
      cells[y][x].add_observer(block) rescue puts "WARNIG:" + $!.message
    end
    blocks.push(block)
    block = Block.new(n)
    (0...n).to_a.zip((0...n).to_a.reverse).each do |x,y|
      block.add(cells[y][x])          rescue puts "WARNIG:" + $!.message
      cells[y][x].add_observer(block) rescue puts "WARNIG:" + $!.message
    end
    blocks.push(block)
    board.set_cells(cells)
    board.set_blocks(blocks)
    board
  end
end
