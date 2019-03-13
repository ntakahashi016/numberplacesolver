# coding: utf-8

require './Number'
require './Cell'

# Class:Block
# 通常のナンプレで横9マス、縦9マス、3x3マスの領域に該当し、
# 領域内の数字に重複がないことをチェックする
class Block

  def initialize()
    @cells = []
    @numbers = {}
    Number.available_values.each do |number|
      @numbers[number] = false
    end
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
    @numbers.each do |k,v|
      @numbers[k] = false
    end
    @cells.each do |cell|
      if cell.number == nil
        next                    # Cellに数字(Numberオブジェクト)が登録されてなければ次へ
      else
        if @numbers[cell.number] == false
          @numbers[cell.number] = true
        else
          @numbers[cell.number] = false
          raise "#{self.class.name} # #{cell.number} is aready exists."
        end
      end
    end
  end

  def solved?
    @numbers.all? do |n|
      n[1] # flag部分
    end
  end
end
