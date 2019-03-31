# coding: utf-8

require './Solver'

class StandardSolver < Solver

  def initialize(board)
    super(board)
  end

  def solve()
    until @board.solved?
      changed = false
      retry_flag = false
      # 候補が一つしか無いセルの値を確定する
      # loop do
      #   changed = fix_single_candidate_cells
      #   break unless changed
      #   retry_flag = true
      # end
      # next if retry_flag
      loop do
        changed = narrow_down_by_linear_candidates
        break unless changed
        changed = false
        changed = fix_single_cell_candidates
        break unless changed
        @board.update_candidates
        retry_flag = true
      end
      next if retry_flag
      unless changed
        raise "問題を解けませんでした"
      end
    end
  end

  private

  def fix_single_candidate_cells
    result = false
    cells = @board.get_empty_cells
    cells.each do |cell|
      if cell.candidates.size == 1
        puts "#{cell.x.to_s},#{cell.y.to_s} => #{cell.candidates.first}"
        @board.set_number(cell.x, cell.y, cell.candidates.first)
        puts @board.to_s
        result = true
      end
    end
    result
  end

  def fix_single_cell_candidates
    result = false
    cells = @board.get_empty_cells
    puts @board.to_s
    cells.each do |cell|
      target_cells = cells & cell.row_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_single_cell_candidates(cell,target_cells)

      target_cells = cells & cell.col_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_single_cell_candidates(cell,target_cells)

      target_cells = cells & cell.box_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_single_cell_candidates(cell,target_cells)
    end
    result
  end

  def __fix_single_cell_candidates(cell,target_cells)
    result = false
    cell.candidates.each do |candidate|
      same_candidate_cells = target_cells.map { |c| c if c.candidates.include?(candidate) }
      same_candidate_cells.compact!
      if same_candidate_cells==[cell]
        puts "#{cell.x.to_s},#{cell.y.to_s} => #{candidate}"
        @board.set_number(cell.x, cell.y, candidate)
        puts @board.to_s
        result = true
      end
    end
    result
  end

  def narrow_down_by_linear_candidates
    result = false
    cells = @board.get_empty_cells
    i = 0
    j = 0
    for i in 0...(cells.size-1) do
      same_row_candidates   = []
      same_col_candidates   = []
      non_linear_candidates = []
      for j in 0...cells.size do
        next if i==j
        next unless cells[i].box_constraints.any? { |c| c.include?(cells[j]) }
        if cells[i].row_constraints.any? { |c| c.include?(cells[j]) }
          same_row_candidates |= cells[i].candidates & cells[j].candidates
        elsif cells[i].col_constraints.any? { |c| c.include?(cells[j]) }
          same_col_candidates |= cells[i].candidates & cells[j].candidates
        else
          non_linear_candidates |= cells[j].candidates
        end
        tmp_same_row_candidates = same_row_candidates
        tmp_same_col_candidates = same_col_candidates
        same_row_candidates   -= tmp_same_col_candidates | non_linear_candidates
        same_col_candidates   -= tmp_same_row_candidates | non_linear_candidates
        non_linear_candidates |= tmp_same_row_candidates & tmp_same_col_candidates
      end
      row_constraints = cells[i].row_constraints
      col_constraints = cells[i].col_constraints
      box_constraints = cells[i].box_constraints
      unless same_row_candidates==[]
        row_constraints.product(box_constraints).each do |constraints|
          target_cells = (constraints.first.cells - constraints.last.cells) & cells
          target_cells.each do |cell|
            cell.delete_candidates(same_row_candidates)
          end
        end
        result = true
      end
      unless same_col_candidates==[]
        col_constraints.product(box_constraints).each do |constraints|
          target_cells = (constraints.first.cells - constraints.last.cells) & cells
          target_cells.each do |cell|
            cell.delete_candidates(same_col_candidates)
          end
        end
        result = true
      end
    end
    result
  end

end
