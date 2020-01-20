# coding: utf-8

require './Solver'
require './Strategy'

class StandardSolver < Solver

  def initialize
    @strategies = []
  end

  def solve()
    i = 0
    until @board.solved?
      changed = @strategies[i].solve(@board)
      if changed
        i = 0
      else
        i += 1
      end
      raise "問題を解けませんでした" if i >= @strategies.size
    end
  end

  def add_strategy(strategy)
    raise TypeError unless Strategy === strategy
    @strategies.push(strategy)
  end
end
