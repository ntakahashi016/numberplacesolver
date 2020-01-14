# coding: utf-8
class FullHouseStrategy < Strategy
  def solve(board)
    # FullHouse ある領域の8つのマスが既に埋まっている場合、残りの一つに入る数字が確定する
    # NakedSingleの特殊パターンでもあるため、使用しなくてもfix_naked_singleで確定できる
    result = false
    cells = board.get_empty_cells
    cells.each do |cell|
      if cell.row_constraints.any? { |c| c.cells.one? { |cell| cell.n == nil } }
        # (空の)cellの属する領域で空のマスが一つの場合、そのマスの候補(一つしか無いはず)が確定する
        puts "#####{self.class.name}##{__method__}:#{cell.x.to_s},#{cell.y.to_s} => #{cell.candidates.first.to_s}"
        board.set_number(cell.x, cell.y, cell.candidates.first)
        board.update_candidates
        puts board.to_s
        result = true
      end
    end
    result
  end
end
