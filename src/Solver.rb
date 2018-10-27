class Solver

  def initialize()
    @solve_units = []
    @algorithm = nil
  end

  def solve()
    if @algorithm!=nil
      # if @solve_units!=[]
      until @algorithm.is_finished?
        @algorithm.do
      end
      # end
    end
  end

  def add_SolveUnit(unit)
    @solve_units.add(unit)
  end

  def del_SolveUnit
    @solve_units.del(unit)
  end

  def set_algorithm(algorithm)
    @algorithm = algorithm
    @algorithm.set_solve_units(@solve_units)
  end

  def del_algorithm()
    @algorithm = nil
  end

end
