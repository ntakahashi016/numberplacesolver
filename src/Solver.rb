# coding: utf-8

require './Strategy'

class Solver

  def initialize
    @strategies = {}
  end

  def solve()
    i = 0
    until @board.solved?
      raise "問題を解けませんでした" if i >= @strategies.size
      names = @strategies.keys
      changed = @strategies[names[i]].solve(@board)
      if changed
        i = 0
      else
        i += 1
      end
    end
  end

  def add_strategy(name,strategy)
    raise TypeError unless String === name
    raise TypeError unless Strategy === strategy
    @strategies[name] = strategy
  end

  def del_strategy(name,strategy)
    raise TypeError unless String === name
    raise TypeError unless Strategy === strategy
    @strategies.delete(name)
  end
end
