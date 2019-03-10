# coding: utf-8

require './Numbers'
require './Cell'

# Class:Block
# 通常のナンプレで横9マス、縦9マス、3x3マスの領域に該当し、
# 領域内の数字に重複がないことをチェックする
class Block

  def initialize()
    @cells = []
  end

  # add
  # 領域にマス(Cellオブジェクト)を登録する
  def add(cell)
    if cell.class == Cell
      @cells.push(cell)
    else
      raise TypeError           # CellオブジェクトでなければTypeError
    end
  end

  # norify
  # 領域内のマスに変更があった場合に、数字に重複がないか
  # チェックする
  def notify()
    numbers = Numbers.new
    @cells.each do |cell|
      if cell.number == nil
        next                    # Cellに数字(Numberオブジェクト)が登録されてなければ次へ
      else
        begin
          numbers.set(cell.number) # Cellの数字をNumbersに登録する
        rescue  => e
          raise e
        end
      end
    end
  end

end
