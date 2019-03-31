# coding: utf-8

require './Solver'

class BacktrackSolver < Solver

  def initialize(board)
    super(board)
  end

  def solve()
    i      = 0  # 対象の空のセルの番号
    stack  = [] # 実行した動作のスタック、内容はハッシュにする
    resume = 0  # 数字が入らなかった場合に前のセルに復帰する際の数字

    # cellsは空のセルの配列
    cells = @board.get_empty_cells
    until @board.solved?
      # 復帰処理でない場合、resumeは0のため候補配列の先頭から実行する
      # 復帰処理の場合、resumeより大きい候補から実行する
      # ただし、すべての候補を試行していた場合、nil
      number = cells[i].candidates.find {|n| resume < n}
      # 候補配列画からの場合、前のセルの処理に復帰する
      # また、すべての候補を試行していた場合も同様に前のセルの処理に復帰する
      if (cells[i].candidates.empty?) || (number==nil)
        # スタックから前の処理を取り出し、取り消す
        prev = stack.pop
        # 前のセルの処理が無い=先頭のセルにいずれの候補も入らなかった場合=>解なし
        if prev == nil
          raise "ERROR 解が見つかりませんでした。"
        end
        # 前の処理を取り消す=数字としてnilを設定する
        @board.set_number(prev[:x], prev[:y], nil)
        # resumeに前回試行した数字を保存しておく
        resume = prev[:n]
        i -= 1
        next
      end
      # 実行する処理をスタックに保存する
      stack.push({x: cells[i].x, y: cells[i].y, n: number})
      # 数字を設定する
      @board.set_number(cells[i].x, cells[i].y, number)
      # 復帰でないためresumeの値を初期化しておく
      resume = 0
      i += 1
    end
  end
end
