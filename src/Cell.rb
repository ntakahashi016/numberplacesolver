# coding: utf-8

require './Constraint'

class Cell
  attr_reader :x,:y,:n,:candidates,\
              :row_constraints,:col_constraints,:box_constraints,\
              :falling_diagonal_constraints,:raising_diagonal_constraints

  def initialize(x,y,n_max)
    @x          = x                # X座標
    @y          = y                # Y座標
    @n_max      = n_max            # 数字の最大値
    @n          = nil              # 数字
    @row_constraints = []
    @col_constraints = []
    @box_constraints = []
    @falling_diagonal_constraints = []
    @raising_diagonal_constraints = []
    @constraints = [@row_constraints, @col_constraints, @box_constraints,\
                    @falling_diagonal_constraints, @raising_diagonal_constraints]
    @candidates = (1..@n_max).to_a # 入りうる数字の候補
  end

  # add_constraint
  # 制約(Constraintオブジェクト)を追加する
  def add_constraint(constraint,type=:extra)
    raise TypeError unless constraint.class==Constraint
    raise TypeError unless type.class==Symbol
    case type
    when :row
      @row_constraints.push(constraint)
    when :col
      @col_constraints.push(constraint)
    when :box
      @box_constraints.push(constraint)
    when :falling_diagonal
      @falling_diagonal_constraints.push(constraint)
    when :raising_diagonal
      @raising_diagonal_constraints.push(constraint)
    else
      raise
    end
  end

  # notify_constraints
  # constraintに変更があったことを通知する
  def notify_constraints()
    @constraints.each do |constraints|
      constraints.each do |constraint|
        constraint.notify rescue raise
      end
    end
  end

  # n=
  # 数字を設定する
  def n=(n)
    raise TypeError  unless (n.class==Integer) || (n.class==NilClass)
    raise RangeError unless (1..@n_max).include?(n) || n==nil
    @n = n
    self.notify_constraints rescue raise
    self.update_candidates
  end

  def update_candidates
    if @n == nil
      @candidates = (1..@n_max).to_a
      @constraints.each do |constraints|
        constraints.each do |constraint|
          @candidates &= constraint.candidates
        end
      end
    else
      @candidates = []
    end
    nil
  end

  def delete_candidates(candidates)
    raise TypeError unless candidates.class==Array
    raise TypeError unless candidates.all? { |c| c.class==Integer }
    @candidates -= candidates
  end

  def to_s
    {x: @x, y: @y, n: @n, candidates: @candidates}.to_s
  end

  def inspect
    to_s
  end
end


