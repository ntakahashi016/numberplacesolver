# coding: utf-8
class Solver

  def initialize(board)
    if board.class == Board
      @board = boad
    else
      raise "Class:#{self.class.name}:TypeError."
    end
    @algorithm = nil
  end

  def solve()
    if @algorithm!=nil
      until @algorithm.is_finished?
        @algorithm.do
      end
    end
  end

  def set_algorithm(algorithm)
    @algorithm = algorithm
  end

end
