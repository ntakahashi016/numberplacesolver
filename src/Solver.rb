# coding: utf-8
class Solver

  def set_board(board)
    raise TypeError,"Class:#{self.class.name}:初期化に失敗しました" unless board.class == Board
    @board = board
  end

  def solve()
  end

  def add_strategy(strategy)
  end
end
