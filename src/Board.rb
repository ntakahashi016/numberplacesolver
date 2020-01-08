# coding: utf-8

require './Cell'
require './Constraint'

class Board
  attr_reader :x_size,:y_size,:n_min,:n_max

  def initialize(n_max)
    @cells       = []     # セルの集合、二次元の配列で盤面と対応させる
    @constraints = []     # 制約の集合
    @x_size      = 0      # 横方向のセルの数
    @y_size      = 0      # 縦方向のせるの数
    @n_min       = 1      # 使用する数字の最小値
    @n_max       = n_max  # 使用する数字の最大値
  end

  def set_cells(cells)
    raise TypeError unless cells.class == Array
    raise TypeError unless cells.all? { |row| row.class==Array }
    result = cells.all? do |row|
      row.all? do |cell|
        (cell.class==Cell) || (cell.class==NilClass)
      end
    end
    raise TypeError unless result
    @x_size = cells.first.size
    @y_size = cells.size
    @cells  = cells
  end

  def get_cells
    @cells.flatten.compact
  end

  def get_empty_cells
    cells = @cells.map do |row|
      row.map do |cell|
        (cell.n==nil) ? cell : nil unless cell==nil
      end
    end
    cells.flatten.compact
  end

  def set_constraints(constraints)
    raise TypeError unless constraints.class == Array
    raise TypeError unless constraints.all? { |c| c.class==Constraint }
    @constraints = constraints
  end

  def get_constraints
    @constraints
  end

  def get_unsolved_constraints
    @constraints.select{|c| !c.solved? }
  end

  # set_number
  # x,y座標で値を設定する
  def set_number(x,y,n)
    begin
      @cells[y][x].n = n unless @cells[y][x]==nil
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
  def set_numbers(numbers)
    raise TypeError unless numbers.class == Array
    raise TypeError unless numbers.all? { |row| row.class==Array}
    numbers.each_with_index do |row,y|
      row.each_with_index do |n,x|
        begin
          set_number(x,y,n) unless @cells[y][x]==nil
        rescue TypeError => e
          puts e.message
        rescue RangeError => e
          puts "WARNING:Class:#{self.class.name}##{__method__} [#{x.to_s},#{y.to_s}]の値(#{n.to_s})は範囲外です。[#{x.to_s},#{y.to_s}]への値の設定をスキップしました。"
        rescue => e
          puts "WARNING:Class:#{self.class.name}##{__method__} [#{x.to_s},#{y.to_s}]の値(#{n.to_s})は重複しています。"
        end
      end
    end
  end

  # get_number
  # x,y座標で値を取得する
  def get_number(x,y)
    if @cells[y][x]==nil
      nil
    else
      @cells[y][x].n
    end
  end

  def get_numbers()
    numbers = []
    for y in 0...@y_size do
      numbers[y] = []
      for x in 0...@x_size do
        numbers[y] << get_number(x,y)
      end
    end
    numbers
  end

  def update_candidates()
    for y in 0...@y_size do
      for x in 0...@x_size do
        @cells[y][x].update_candidates unless @cells[y][x]==nil
      end
    end
    nil
  end

  # to_s
  # 盤面を簡易的に文字列にして返す
  def to_s
    str = ""
    for y in 0...@y_size do
      str << "+--" * @x_size  + "+\n"
      for x in 0...@x_size do
        str << "|"
        if @cells[y][x] == nil
          str << "xx"
        else
        num = get_number(x,y)
        if num == nil
          str << "  "
        else
          str << sprintf("%2d",num)
        end
        end
      end
      str << "|\n"
    end
    str << "+--" * @x_size  + "+\n"
    str
  end

  # solved?
  # 問題が解けているかどうか返す
  def solved?
    @constraints.all? {|constraint| constraint.solved? }
  end
end
