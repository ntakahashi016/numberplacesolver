# coding: utf-8

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
  end

  def set_cells(cells)
    @x_size = cells.first.size
    @y_size = cells.size
    @cells = cells
  end

  def get_cells
    @cells
  end

  def get_empty_cells
    cells = @cells.map do |row|
      row.map do |cell|
        (cell.number==nil) ? cell : nil
      end
    end
    cells.flatten.compact
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
      refresh_candidates
    rescue RangeError => e
      raise e
    rescue TypeError => e
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
        rescue TypeError => e
          puts e.message
        rescue => e
          puts "WARNING:Class:#{self.class.name}##{__method__} [#{x.to_s},#{y.to_s}]の値(#{number.to_s})は重複しています。"
        end
      end
    end
    refresh_candidates
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

  def refresh_candidates()
    for y in 0...self.y_size do
      for x in 0...self.x_size do
        @cells[y][x].refresh_candidates
      end
    end
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

  b = Board.new(9)
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

  b = Board.new(9)
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

  b = Board.new(9)
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
