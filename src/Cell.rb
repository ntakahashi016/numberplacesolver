# coding: utf-8

require './Constraint'

class Cell
  attr_reader :x,:y,:n,:candidates

  def initialize(x,y,n_max)
    @x          = x                # X座標
    @y          = y                # Y座標
    @n_max      = n_max            # 数字の最大値
    @n          = nil              # 数字
    @observers  = []               # 変更通知対象
    @candidates = (1..@n_max).to_a # 入りうる数字の候補
  end

  # add_observer
  # observer(Constraintオブジェクト)を追加する
  def add_observer(constraint)
    raise TypeError unless constraint.class==Constraint
    @observers.push(constraint)
  end

  # notify_observers
  # observerに変更があったことを通知する
  def notify_observers()
    @observers.each do |constraint|
    constraint.notify rescue raise
    end
  end

  # n=
  # 数字を設定する
  def n=(n)
    raise TypeError  unless (n.class==Integer) || (n.class==NilClass)
    raise RangeError unless (1..@n_max).include?(n) || n==nil
    @n = n
    self.notify_observers rescue raise
    self.update_candidates
  end

  def update_candidates
    if @n == nil
      @candidates = (1..@n_max).to_a
      @observers.each do |constraint|
        @candidates &= constraint.candidates
      end
    else
      @candidates = []
    end
    nil
  end
end


