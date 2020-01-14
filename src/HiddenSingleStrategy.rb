# coding: utf-8
class HiddenSingleStrategy < Strategy
  def solve(board)
    # HiddenSingle ある数字が一つの領域で配置できるマスが一つに限られる場合、そこに入る数字が確定する
    result = false
    cells = board.get_empty_cells
    cells.each do |cell|
      # いずれかの領域で数字を確定できたらresultをtrueにする
      target_cells = cells & cell.row_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(board,cell,target_cells)

      target_cells = cells & cell.cul_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(board,cell,target_cells)

      target_cells = cells & cell.box_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(board,cell,target_cells)

      target_cells = cells & cell.falling_diagonal_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(board,cell,target_cells)

      target_cells = cells & cell.raising_diagonal_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(board,cell,target_cells)
    end
    result
  end

  private

  def __fix_hidden_single(board,cell,target_cells)
    # fix_hidden_singleにおける共通処理
    # cellの各候補において同一領域(target_cells)内に配置できるマスがcellに限られるものがあるか調べる
    result = false
    cell.candidates.each do |candidate|
      same_candidate_cells = target_cells.map { |c| c if c.candidates.include?(candidate) }
      same_candidate_cells.compact!
      if same_candidate_cells==[cell]
        puts "#####{self.class.name}##{__method__}:#{cell.x.to_s},#{cell.y.to_s} => #{candidate.to_s}"
        board.set_number(cell.x, cell.y, candidate)
        board.update_candidates
        puts board.to_s
        result = true
      end
    end
    result
  end

end
