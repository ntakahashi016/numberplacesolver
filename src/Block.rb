# coding: utf-8

require './Cell'

# Class:Block
# 通常のナンプレで横9マス、縦9マス、3x3マスの領域に該当し、
# 領域内の数字に重複がないことをチェックする
class Block

  def initialize(n)
    @cells = []
    @n = n
    @candidates = (1..n).to_a
  end

  # add
  # 領域にマス(Cellオブジェクト)を登録する
  def add(cell)
    if cell.class == Cell
      @cells.push(cell)
    else
      raise TypeError,"Class:#{self.class.name}#add(cell) BlockにはCellオブジェクトしか登録できません。(#{cell.class.name})"
    end
  end

  # norify
  # 領域内のマスに変更があった場合に、数字に重複がないか
  # チェックする
  def notify()
    @candidates = (1..@n).to_a
    @cells.each do |cell|
      if cell.number == nil
        next                    # Cellに数字(Numberオブジェクト)が登録されてなければ次へ
      else
        if @candidates.include?(cell.number)
          @candidates -= [cell.number]
        else
          raise "#Class:{self.class.name}#norify() #{cell.number} はBlockに既に存在します。"
        end
      end
    end
    @candidates
  end

  def get_candidates
    @candidates
  end

  def solved?
    @candidates == []
  end
end
