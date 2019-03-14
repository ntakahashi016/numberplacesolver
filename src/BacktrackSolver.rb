# coding: utf-8

require './Solver'
require './Board'
require './Command'

class BacktrackSolver < Solver

  def initialize(board)
    super(board)
  end

  def solve()
    cmd_stack = CompositCommand.new
    idx = 0   # インデックス
    resume = false # 復帰フラグ

    until @board.solved?
      y = idx/9 # インデックスをもとにY座標を生成
      x = idx%9 # インデックスをもとにX座標を生成
      num = @board.get_number(x,y)
      if !resume
        # 復帰でなくすでに数字が入っている場合、問題の数字であるため次のマスへすすめる
        if num != nil
          idx += 1
          next
        else
          start = 1 # マスが空の場合は1から始める
        end
      else
        # 復帰の場合、すでに入っている数字の次から始める
        if num != nil
          start = num + 1
        else
          # デバッグ用 実行時エラー
          raise "ERROR(DEBUG) [#{x},#{y}]の処理に復帰しましたが #{num} がすでにセットされています"
        end
      end
      # 開始番号から使用する最大値までで、当てはまる数字が一つもないかどうかチェックする
      result = (start..9).none? do |n|
        begin
          cmd = SetCommand.new(@board,x,y,n)
          cmd_stack.push(cmd)
          cmd.do
          true # 数字が問題なくセットできた
        rescue RangeError => e
          # デバッグ用 Rangeエラー 使用する数字の範囲に誤りがある場合
          raise e.message
        rescue
          cmd.undo
          cmd_stack.pop
          false # 数字がセットできなかった＝番号の重複があった
        end
      end
      # result==trueはどの数字も当てはまらなかった場合
      if result == true
        # 一つ前のコマンドを取り出す
        prev_cmd = cmd_stack.pop
        if prev_cmd == nil
          # コマンド履歴の最初まで遡った＝最初のマスでどの数字も当てはまらなかった場合、失敗
          raise "ERROR 解が見つかりませんでした"
        end
        idx = (prev_cmd.y * 9) + prev_cmd.x # 前回実行したコマンドのインデックスに移動する
        # 前回のコマンドで最大値をセットしていた場合はundoを実行し更に前のコマンド実行時のインデックスに移動する
        while prev_cmd.number == 9 do
          prev_cmd.undo
          prev_cmd = cmd_stack.pop
          idx = (prev_cmd.y * 9) + prev_cmd.x
        end
        resume = true # 復帰フラグを立てる
      else
        if result == nil
          # デバッグ用 resultがnilの場合＝チェック範囲の指定ミス
          raise "ERROR(DEBUG) [#{x},#{y}]で数字のチェックに失敗しました"
        end
        # result==falseは数字が当てはまった場合、次のマスに進む
        idx += 1
        resume = false
      end
      # デバッグ用 インデックスがBoardのサイズを超える＝最後のマスに数字が入ったがsolved?==falseの場合
      if idx > (@board.x_size * @board.y_size)
        raise "ERROR 最後のマスまで到達しましたが問題を解けませんでした"
      end
    end

  end

end
