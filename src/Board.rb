# coding: utf-8

require './Number'
require './Cell'
require './Block'

class Board

  def initialize()
    @cells = []
    @blocks = []
    board_col,board_row = 9,9     # 暫定で通常の9x9に対応
    block_col,block_row = 3,3
    # 使用する数字の範囲を規定する
    begin
      Number.set_min_value(1)
      Number.set_max_value(9)
    rescue RangeError => e
      raise e
    end
    # Board上の全Cellを生成
    for y in 0...board_row do
      @cells[y] = []
      for x in 0...board_col do
        @cells[y][x] = Cell.new(x,y)
      end
    end
    # 横一列のBlockにCellを登録
    for y in 0...board_row do
      block = Block.new
      for x in  0...board_col do
        block.add(@cells[y][x])
        @cells[y][x].add_observer(block)
      end
      @blocks.push(block)
    end
    # 縦一列のBlockにCellを登録
    for x in 0...board_col do
      block = Block.new
      for y in 0...board_row do
        block.add(@cells[y][x])
        @cells[y][x].add_observer(block)
      end
      @blocks.push(block)
    end
    # NxN領域にCellを登録
    for i in 0...(board_row/block_row) do
      for j in 0...(board_col/block_col) do
        block = Block.new
        for k in 0...block_row do
          for l in 0...block_col do
            y = (i*block_row) + k
            x = (j*block_col) + l
            block.add(@cells[y][x])
            @cells[y][x].add_observer(block)
          end
        end
        @blocks.push(block)
      end
    end
  end

  # set_number
  # x,y座標で値を設定する
  def set_number(x,y,n)
    begin
      @cells[y][x].number = n
    rescue RangeError => e
      raise e
    rescue => e
      raise e
    end
  end

  # get_number
  # x,y座標で値を取得する
  def get_number(x,y)
    @cells[y][x].number
  end

  def x_size
    @cells[0].size
  end

  def y_size
    @cells.size
  end

  # to_s
  # 盤面を簡易的に文字列にして返す
  def to_s
    str = ""
    for y in 0...self.y_size do
      str << "+-" * self.x_size  + "+\n"
      for x in 0...self.x_size do
        str << "|"
        num = self.get_number(x,y)
        if num == nil
          str << " "
        else
          str << num.to_s
        end
      end
      str << "|\n"
    end
    str << "+-" * self.x_size  + "+\n"
    str
  end

  # solved?
  # 問題が解けているかどうか返す
  def solved?
    @blocks.all? {|block| block.solved? }
  end
end


#test
if $0 == __FILE__
  require './Command'
  require './BacktrackSolver'

  b = Board.new()
  puts b.to_s
  if b.solved?
    puts "#### SOLVED ####"
  else
    puts "#### NOT SOLVED ####"
  end

  numarr = (1..9).to_a
  for y in 0..8 do
    for x in 0..8 do
      i = (x + y/3 + 0) % 9 if (y % 3) == 0
      i = (x + y/3 + 3) % 9 if (y % 3) == 1
      i = (x + y/3 + 6) % 9 if (y % 3) == 2
      begin
        b.set_number(x,y,numarr[i])
      rescue => e
        puts "Error #{e.message}"
      end
    end
    puts b.to_s
  end
  puts "################################################################"
  puts b.to_s
  puts "################################################################"
  if b.solved?
    puts "#### SOLVED ####"
  else
    puts "#### NOT SOLVED ####"
  end
  puts "################################################################"
  # for x in 0..8 do
  #   for y in 0..8 do
  #     puts "get_number(#{x},#{y}) : #{b.get_number(x,y)}"
  #   end
  # end
  begin
    b.set_number(0,0,0)
  rescue => e
    puts e.message
  end
  begin
    b.set_number(0,0,2)
  rescue => e
    puts e.message
  end
  if b.solved?
    puts "#### SOLVED ####"
  else
    puts "#### NOT SOLVED ####"
  end
  puts "################################################################"

  b = Board.new()
  init_cmd_stack = CompositCommand.new
  init_cmd_stack.push(SetCommand.new(b,0,0,5))
  init_cmd_stack.push(SetCommand.new(b,1,0,3))
  init_cmd_stack.push(SetCommand.new(b,4,0,7))
  init_cmd_stack.push(SetCommand.new(b,0,1,6))
  init_cmd_stack.push(SetCommand.new(b,3,1,1))
  init_cmd_stack.push(SetCommand.new(b,4,1,9))
  init_cmd_stack.push(SetCommand.new(b,5,1,5))
  init_cmd_stack.push(SetCommand.new(b,1,2,9))
  init_cmd_stack.push(SetCommand.new(b,2,2,8))
  init_cmd_stack.push(SetCommand.new(b,7,2,6))
  init_cmd_stack.push(SetCommand.new(b,0,3,8))
  init_cmd_stack.push(SetCommand.new(b,4,3,6))
  init_cmd_stack.push(SetCommand.new(b,8,3,3))
  init_cmd_stack.push(SetCommand.new(b,0,4,4))
  init_cmd_stack.push(SetCommand.new(b,3,4,8))
  init_cmd_stack.push(SetCommand.new(b,5,4,3))
  init_cmd_stack.push(SetCommand.new(b,8,4,1))
  init_cmd_stack.push(SetCommand.new(b,0,5,7))
  init_cmd_stack.push(SetCommand.new(b,4,5,2))
  init_cmd_stack.push(SetCommand.new(b,8,5,6))
  init_cmd_stack.push(SetCommand.new(b,1,6,6))
  init_cmd_stack.push(SetCommand.new(b,6,6,2))
  init_cmd_stack.push(SetCommand.new(b,7,6,8))
  init_cmd_stack.push(SetCommand.new(b,3,7,4))
  init_cmd_stack.push(SetCommand.new(b,4,7,1))
  init_cmd_stack.push(SetCommand.new(b,5,7,9))
  init_cmd_stack.push(SetCommand.new(b,8,7,5))
  init_cmd_stack.push(SetCommand.new(b,4,8,8))
  init_cmd_stack.push(SetCommand.new(b,7,8,7))
  init_cmd_stack.push(SetCommand.new(b,8,8,9))
  init_cmd_stack.do

  puts b

  solver = BacktrackSolver.new(b)
  solver.solve

  puts b
  if b.solved?
    puts "#### SOLVED ####"
  else
    puts "#### NOT SOLVED ####"
  end

end
