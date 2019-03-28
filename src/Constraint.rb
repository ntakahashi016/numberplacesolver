# coding: utf-8

require './Cell'

# Class:Constraint
# 通常のナンプレで横9マス、縦9マス、3x3マスの領域に該当し、
# 領域内の数字に重複がないことをチェックする
class Constraint
  attr_reader :candidates

  def initialize(n_max)
    @cells      = []               # 領域内のセルの集合
    @n_max      = n_max            # 数字の最大値
    @candidates = (1..@n_max).to_a # 領域内に入りうる数字の候補（未確定の数字）
  end

  # add
  # 領域にマス(Cellオブジェクト)を登録する
  def add(cell)
    raise TypeError unless cell.class == Cell
    @cells.push(cell)
  end

  # norify
  # 領域内のマスに変更があった場合に、数字に重複がないかチェックする
  def notify()
    @candidates = (1..@n_max).to_a
    @cells.each do |cell|
      next if cell.n == nil # Cellに数字が登録されてなければ次へ
      # 領域内に入り得ない数字が見つかった
      raise unless @candidates.include?(cell.n)
      @candidates -= [cell.n]
    end
    nil
  end

  # solved?
  # 制約が充足されているかどうかを返す
  # 未確定の数字がなければtrue
  def solved?
    @candidates == []
  end
end
