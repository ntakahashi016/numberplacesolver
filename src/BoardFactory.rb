# coding: utf-8

require './Factory'
require './Cell'
require './Constraint'
require './Board'

class StandardBoardFactory < Factory
  def generate(n)
    board       = Board.new(n)
    cells       = []
    constraints = []
    box_size    = Integer.sqrt(n)
    unless box_size ** 2 == n
      raise "Class:#{self.class.name}##{__method__} 指定したサイズ(#{n})では盤面を生成できません。平方根が整数となる数値を使用してください"
    end

    # Board上の全Cellを生成
    for y in 0...n do
      cells[y] = []
      for x in 0...n do
        cells[y][x] = Cell.new(x,y,n)
        cells[y][x].update_candidates
      end
    end
    # 横一列のConstraintにCellを登録
    for y in 0...n do
      constraint = Constraint.new(n)
      for x in  0...n do
        constraint.add(cells[y][x])          rescue puts "WARNIG:" + $!.message
        cells[y][x].add_observer(constraint) rescue puts "WARNIG:" + $!.message
      end
      constraints.push(constraint)
    end
    # 縦一列のConstraintにCellを登録
    for x in 0...n do
      constraint = Constraint.new(n)
      for y in 0...n do
        constraint.add(cells[y][x])          rescue puts "WARNIG:" + $!.message
        cells[y][x].add_observer(constraint) rescue puts "WARNIG:" + $!.message
      end
      constraints.push(constraint)
    end
    # Box領域にCellを登録
    for i in 0...(n/box_size) do
      for j in 0...(n/box_size) do
        constraint = Constraint.new(n)
        for k in 0...box_size do
          for l in 0...box_size do
            y = (i*box_size) + k
            x = (j*box_size) + l
            constraint.add(cells[y][x])          rescue puts "WARNIG:" + $!.message
            cells[y][x].add_observer(constraint) rescue puts "WARNIG:" + $!.message
          end
        end
        constraints.push(constraint)
      end
    end

    board.set_cells(cells)
    board.set_constraints(constraints)
    board
  end
end

class DiagonalBoardFactory < StandardBoardFactory
  def generate(n)
    board = super(n)
    cells = board.get_cells
    constraints = board.get_constraints
    constraint = Constraint.new(n)
    (0...n).to_a.zip((0...n).to_a).each do |x,y|
      constraint.add(cells[y][x])          rescue puts "WARNIG:" + $!.message
      cells[y][x].add_observer(constraint) rescue puts "WARNIG:" + $!.message
    end
    constraints.push(constraint)
    constraint = Constraint.new(n)
    (0...n).to_a.zip((0...n).to_a.reverse).each do |x,y|
      constraint.add(cells[y][x])          rescue puts "WARNIG:" + $!.message
      cells[y][x].add_observer(constraint) rescue puts "WARNIG:" + $!.message
    end
    constraints.push(constraint)
    board.set_cells(cells)
    board.set_constraints(constraints)
    board
  end
end
