# coding: utf-8

require './Number'
require './Cell'
require './Block'
require './Command'

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

  def solved?
    @blocks.all? {|block| block.solved? }
  end
end


#test

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

cmd_stack = CompositCommand.new
idx = 0   # インデックス
resume = false # 復帰フラグ

until b.solved?
  y = idx/9 # インデックスをもとにY座標を生成
  x = idx%9 # インデックスをもとにX座標を生成
  num = b.get_number(x,y)
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
      raise
    end
  end
  # 開始番号から使用する最大値までで、当てはまる数字が一つもないかどうかチェックする
  result = (start..9).none? do |n|
    begin
      cmd = SetCommand.new(b,x,y,n)
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
      raise
    end
    idx = (prev_cmd.y * 9) + prev_cmd.x # 前回実行したコマンドのインデックスに移動する
    # 前回のコマンドで最大値をセットしていた場合は更にundoを実行しもう一つ前のコマンド実行時のインデックスに移動する
    if prev_cmd.number == 9
      prev_cmd.undo
      prev_cmd = cmd_stack.pop
      idx = (prev_cmd.y * 9) + prev_cmd.x
    end
    resume = true # 復帰フラグを立てる
  else
    if result == nil
      # デバッグ用 resultがnilの場合＝チェック範囲の指定ミス
      raise
    end
    # result==falseは数字が当てはまった場合、次のマスに進む
    idx += 1
    resume = false
  end
  # デバッグ用 インデックスがBoardのサイズを超える＝最後のマスに数字が入ったがresolved?==falseの場合
  if idx > (b.x_size * b.y_size)
    raise
  end
end

puts b
if b.solved?
  puts "#### SOLVED ####"
else
  puts "#### NOT SOLVED ####"
end
