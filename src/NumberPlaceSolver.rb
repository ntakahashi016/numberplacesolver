# coding: utf-8
require 'qml'
require 'csv'
require './StandardBoardFactory'
require './StandardSolver'
require './LastDigitStrategy'
require './FullHouseStrategy'
require './NakedSingleStrategy'
require './HiddenSingleStrategy'
require './LockedCandidatesType1Strategy'
require './LockedCandidatesType2RowStrategy'
require './LockedCandidatesType2CulStrategy'
require './HiddenSubsetsStrategy'
require './NakedSubsetsStrategy'
require './TemplateStrategy'
require './BacktrackStrategy'
require 'benchmark'

class NumberPlaceSolver
  include QML::Access
  register_to_qml under: "NumberPlaceSolver", version: "1.0"

  property(:board_x) {9}
  property(:num_of_cells) {self.board_x**2}
  property(:num_type) {9}
  property(:panel_x) {Integer.sqrt(self.num_type)}

  @@solver = StandardSolver.new
  @@board = nil
  @@factory = StandardBoardFactory.new

  # mainwindow.qmlからセルの配列を受け取る
  def set_cellarray(cellarray)
    case @@factory
    when StandardBoardFactory
      @@board = @@factory.generate(self.num_type)
    end
    # Boardが受付可能な形式にセルの配列を変換する
    numbers = gen_numbers(cellarray)
    @@board.set_numbers(numbers)
    @@board.update_candidates
    # qml側に値を戻さない
    nil
  end

  def select_board_factory(str_option)
    case str_option.to_sym
    when :standard
      @@factory = StandardBoardFactory.new
    else
      raise "不明なボード種別です"
    end
    nil
  end

  # 問題を解く
  def solve
    puts "#{self.class.name}##{__method__} called."
    puts @@board
    @@solver.set_board(@@board)
    result_time = Benchmark.realtime do
      puts "#### #{@@solver.class.name}で問題を解きます"
      begin
        @@solver.solve
      rescue => e
        puts "#### #{@@solver.class.name}では問題を解けませんでした"
        puts e.message
      end
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
    n = n.to_i
    # GUI描画に影響するため計算順序に注意
    self.num_of_cells = n**2
    self.board_x      = n
    self.num_type     = n
    self.panel_x      = Integer.sqrt(n)
  end

  def save_as(path, cell_array)
    puts "#{self.class.name}##{__method__} #{path}"
    numbers = gen_numbers(cell_array)
    begin
      CSV.open(path, "w") do |csv|
        numbers.each do |row|
          csv << row
        end
      end
    rescue => e
      puts e.message
      return false
    end
    true
  end

  def open(path)
    puts "#{self.class.name}##{__method__} #{path}"
    begin
      csv_data = CSV.read(path)
    rescue => e
      puts e.message
      return []
    end
    csv_data.flatten
  end

  def set_settings(qml_js_obj)
    qml_js_obj.to_hash.to_a.reverse.to_h.each do |k,v|
      if v == 2.0 # 2.0はQML::CheckBoxのcheckStateが取るQt.Checkedの値＝チェックされている
        if k == "HiddenSubsets" || k == "NakedSubsets"
          for i in 2..4
            @@solver.add_strategy(k,Object.const_get(k+'Strategy').new(i))
          end
        else
          @@solver.add_strategy(k,Object.const_get(k+'Strategy').new)
        end
      else
        if k == "HiddenSubsets" || k == "NakedSubsets"
          for i in 2..4
            @@solver.del_strategy(k,Object.const_get(k+'Strategy').new(i))
          end
        else
          @@solver.del_strategy(k,Object.const_get(k+'Strategy').new)
        end
      end
    end
  end
end

# アプリケーション実行
QML.run do |app|
  app.load_path Pathname(__FILE__) + '../ui/mainwindow.qml'
end


