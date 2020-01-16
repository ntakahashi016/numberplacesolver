# coding: utf-8

require './Solver'
require './Strategy'
require './LastDigitStrategy'
require './FullHouseStrategy'
require './NakedSingleStrategy'
require './HiddenSingleStrategy'
require './LockedCandidatesType1Strategy'
require './LockedCandidatesType2RowStrategy'
require './LockedCandidatesType2CulStrategy'
require './HiddenSubsetsStrategy'
require './NakedSubsetsStrategy'

class StandardSolver < Solver

  def initialize(board)
    super(board)
    @strategies = [LastDigitStrategy.new,
                   FullHouseStrategy.new,
                   NakedSingleStrategy.new,
                   HiddenSingleStrategy.new,
                   LockedCandidatesType1Strategy.new,
                   LockedCandidatesType2RowStrategy.new,
                   LockedCandidatesType2CulStrategy.new,
                   # HiddenSubsetsStrategy.new(2),
                   # HiddenSubsetsStrategy.new(3),
                   # HiddenSubsetsStrategy.new(4),
                   NakedSubsetsStrategy.new(2),
                   NakedSubsetsStrategy.new(3),
                   NakedSubsetsStrategy.new(4)]
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
end
