# coding: utf-8

require './Number'
require './Cell'
require './Block'

class Board

  attr_reader :x_size,:y_size,:min,:max
  def initialize(n)
    @cells = []
    @blocks = []
    @x_size = 0
    @y_size = 0
    @min = 1
    @max = n
    # 使用する数字の範囲を規定する
    begin
      Number.set_min_value(@min)
      Number.set_max_value(@max)
    rescue RangeError => e
      raise e
    end
  end

  def set_cells(cells)
    @x_size = cells.first.size
    @y_size = cells.size
    @cells = cells
  end

  def get_cells
    @cells
  end

  def set_blocks(blocks)
    @blocks = blocks
  end

  def get_blocks
    @blocks
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

  # set_numbers
  # 値を配列から入力する
  def set_numbers(numbers_array)
    if numbers_array.class != Array
      raise TypeError, "Class:#{self.class.name}##{__method__} 引数がArrayではありません。(#{numbers_array.class.name})"
    end
    result = numbers_array.all? { |numbers| (numbers.class == Array)||(numbers.class == NilClass) }
    unless result
      raise TypeError, "Class:#{self.class.name}##{__method__} 引数のArrayオブジェクトの内容にArrayまたはNilでないものが含まれています。"
    end
    numbers_array.each_with_index do |numbers,y|
      numbers.each_with_index do |number,x|
        begin
          self.set_number(x,y,number)
        rescue RangeError => e
          puts "WARNING:Class:#{self.class.name}##{__method__} [#{x.to_s},#{y.to_s}]の値(#{number.to_s})は範囲外です。[#{x.to_s},#{y.to_s}]への値の設定をスキップしました。"
        rescue => e
          puts "WARNING:Class:#{self.class.name}##{__method__} [#{x.to_s},#{y.to_s}]の値(#{number.to_s})は重複しています。"
        end
      end
    end
  end

  # get_number
  # x,y座標で値を取得する
  def get_number(x,y)
    @cells[y][x].number
  end

  def get_numbers()
    numbers_array = []
    for y in 0...self.y_size do
      numbers_array[y] = []
      for x in 0...self.x_size do
        numbers_array[y] << get_number(x,y)
      end
    end
    numbers_array
  end

  # to_s
  # 盤面を簡易的に文字列にして返す
  def to_s
    str = ""
    for y in 0...self.y_size do
      str << "+--" * self.x_size  + "+\n"
      for x in 0...self.x_size do
        str << "|"
        num = self.get_number(x,y)
        if num == nil
          str << "  "
        else
          str << sprintf("%2d",num)
        end
      end
      str << "|\n"
    end
    str << "+--" * self.x_size  + "+\n"
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
  # init_cmd_stack = CompositCommand.new
  # init_cmd_stack.push(SetCommand.new(b,0,0,5))
  # init_cmd_stack.push(SetCommand.new(b,1,0,3))
  # init_cmd_stack.push(SetCommand.new(b,4,0,7))
  # init_cmd_stack.push(SetCommand.new(b,0,1,6))
  # init_cmd_stack.push(SetCommand.new(b,3,1,1))
  # init_cmd_stack.push(SetCommand.new(b,4,1,9))
  # init_cmd_stack.push(SetCommand.new(b,5,1,5))
  # init_cmd_stack.push(SetCommand.new(b,1,2,9))
  # init_cmd_stack.push(SetCommand.new(b,2,2,8))
  # init_cmd_stack.push(SetCommand.new(b,7,2,6))
  # init_cmd_stack.push(SetCommand.new(b,0,3,8))
  # init_cmd_stack.push(SetCommand.new(b,4,3,6))
  # init_cmd_stack.push(SetCommand.new(b,8,3,3))
  # init_cmd_stack.push(SetCommand.new(b,0,4,4))
  # init_cmd_stack.push(SetCommand.new(b,3,4,8))
  # init_cmd_stack.push(SetCommand.new(b,5,4,3))
  # init_cmd_stack.push(SetCommand.new(b,8,4,1))
  # init_cmd_stack.push(SetCommand.new(b,0,5,7))
  # init_cmd_stack.push(SetCommand.new(b,4,5,2))
  # init_cmd_stack.push(SetCommand.new(b,8,5,6))
  # init_cmd_stack.push(SetCommand.new(b,1,6,6))
  # init_cmd_stack.push(SetCommand.new(b,6,6,2))
  # init_cmd_stack.push(SetCommand.new(b,7,6,8))
  # init_cmd_stack.push(SetCommand.new(b,3,7,4))
  # init_cmd_stack.push(SetCommand.new(b,4,7,1))
  # init_cmd_stack.push(SetCommand.new(b,5,7,9))
  # init_cmd_stack.push(SetCommand.new(b,8,7,5))
  # init_cmd_stack.push(SetCommand.new(b,4,8,8))
  # init_cmd_stack.push(SetCommand.new(b,7,8,7))
  # init_cmd_stack.push(SetCommand.new(b,8,8,9))
  # init_cmd_stack.do
  numbers_array = [[  5,  3,nil,nil,  7,nil,nil,nil,nil],
                   [  6,nil,nil,  1,  9,  5,nil,nil,nil],
                   [nil,  9,  8,nil,nil,nil,nil,  6,nil],
                   [  8,nil,nil,nil,  6,nil,nil,nil,  3],
                   [  4,nil,nil,  8,nil,  3,nil,nil,  1],
                   [  7,nil,nil,nil,  2,nil,nil,nil,  6],
                   [nil,  6,nil,nil,nil,nil,  2,  8,nil],
                   [nil,nil,nil,  4,  1,  9,nil,nil,  5],
                   [nil,nil,nil,nil,  8,nil,nil,  7,  9]]
  b.set_numbers(numbers_array)

  puts b

  solver = BacktrackSolver.new(b)
  solver.solve

  puts b
  if b.solved?
    puts "#### SOLVED ####"
  else
    puts "#### NOT SOLVED ####"
  end

  b = Board.new()
  # init_cmd_stack = CompositCommand.new
  # init_cmd_stack.push(SetCommand.new(b,0,0,3))
  # init_cmd_stack.push(SetCommand.new(b,2,0,6))
  # init_cmd_stack.push(SetCommand.new(b,4,0,8))
  # init_cmd_stack.push(SetCommand.new(b,2,1,7))
  # init_cmd_stack.push(SetCommand.new(b,8,1,6))
  # init_cmd_stack.push(SetCommand.new(b,1,2,8))
  # init_cmd_stack.push(SetCommand.new(b,3,2,7))
  # init_cmd_stack.push(SetCommand.new(b,6,2,1))
  # init_cmd_stack.push(SetCommand.new(b,0,3,1))
  # init_cmd_stack.push(SetCommand.new(b,1,3,4))
  # init_cmd_stack.push(SetCommand.new(b,7,3,5))
  # init_cmd_stack.push(SetCommand.new(b,0,4,6))
  # init_cmd_stack.push(SetCommand.new(b,5,4,5))
  # init_cmd_stack.push(SetCommand.new(b,6,4,9))
  # init_cmd_stack.push(SetCommand.new(b,8,4,2))
  # init_cmd_stack.push(SetCommand.new(b,3,5,4))
  # init_cmd_stack.push(SetCommand.new(b,6,5,6))
  # init_cmd_stack.push(SetCommand.new(b,3,6,6))
  # init_cmd_stack.push(SetCommand.new(b,5,6,3))
  # init_cmd_stack.push(SetCommand.new(b,8,6,7))
  # init_cmd_stack.push(SetCommand.new(b,0,7,4))
  # init_cmd_stack.push(SetCommand.new(b,5,7,1))
  # init_cmd_stack.push(SetCommand.new(b,6,7,8))
  # init_cmd_stack.push(SetCommand.new(b,5,8,4))
  # init_cmd_stack.push(SetCommand.new(b,7,8,3))
  # init_cmd_stack.do
  numbers_array = [[  3,nil,  6,nil,  8,nil,nil,nil,nil],
                   [nil,nil,  7,nil,nil,nil,nil,nil,  6],
                   [nil,  8,nil,  7,nil,nil,  1,nil,nil],
                   [  1,  4,nil,nil,nil,nil,nil,  5,nil],
                   [  6,nil,nil,nil,nil,  5,  9,nil,  2],
                   [nil,nil,nil,  4,nil,nil,  6,nil,nil],
                   [nil,nil,nil,  6,nil,  3,nil,nil,  7],
                   [  4,nil,nil,nil,nil,  1,  8,nil,nil],
                   [nil,nil,nil,nil,nil,  4,nil,  3,nil]]
  b.set_numbers(numbers_array)
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
