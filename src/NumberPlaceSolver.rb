# coding: utf-8
require 'qml'
require './BoardFactory'
require './BacktrackSolver'
require './StandardSolver'
require 'benchmark'

class NumberPlaceSolver
  include QML::Access
  register_to_qml under: "NumberPlaceSolver", version: "1.0"

  property(:board_x) {9}
  property(:num_of_cells) {self.board_x**2}
  property(:num_type) {9}
  property(:panel_x) {Integer.sqrt(self.num_type)}

  @@solver = nil
  @@board = nil
  @@factory = StandardBoardFactory.new

  # mainwindow.qmlからセルの配列を受け取る
  def set_cellarray(cellarray)
    @@board = @@factory.generate(self.num_type)
    # @@board = NxNBoardFactory.generate(self.num_type)
    # Boardが受付可能な形式にセルの配列を変換する
    numbers = gen_numbers(cellarray)
    @@board.set_numbers(numbers)
    @@solver = BacktrackSolver.new(@@board)
    # qml側に値を戻さない
    nil
  end

  def set_diagonal_type(flag)
    if flag
      @@factory = DiagonalBoardFactory.new
    else
      @@factory = StandardBoardFactory.new
    end
    nil
  end

  # 問題を解く
  def solve
    puts "#{self.class.name}##{__method__} called."
    puts @@board
    result_time = Benchmark.realtime do
      @@solver.solve
    end
    puts "## 処理時間:#{result_time}s"
    puts @@board
    if @@board.solved?
      puts "#### SOLVED ####"
    else
      puts "#### NOT SOLVED ####"
    end
    # 解をqml側の配列の形式に合わせて返す
    @@board.get_numbers.flatten.map{|n| (n==nil) ? "" : n.to_s}
  end

  # セルの配列をqml側の形式からruby側の形式に変換する
  # 空文字列をnilに、文字列の数字を整数に変換する
  def gen_numbers(cellarray)
    puts "#{self.class.name}##{__method__} called."
    cellarray = cellarray.to_a.map { |cell|
      if cell == ""
        nil
      else
        cell.to_i
      end
    }
    cellarray = cellarray.each_slice(self.num_type).to_a
  end

  # 対象の問題の種類を設定する
  def setBoardType(n)
    self.board_x      = n.to_i
    self.num_of_cells = (n**2).to_i
    self.num_type     = n.to_i
    self.panel_x      = Integer.sqrt(n)
  end

end

# アプリケーション実行
QML.run do |app|
  app.load_path Pathname(__FILE__) + '../ui/mainwindow.qml'
end


