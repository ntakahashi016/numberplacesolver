# coding: utf-8
class Solver

  def initialize(board)
    if Board === board
      @board = board
    else
      raise TypeError,"Class:#{self.class.name}:初期化に失敗しました"
    end
  end

  def solve()
  end

end
