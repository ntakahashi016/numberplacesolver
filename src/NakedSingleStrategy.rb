# coding: utf-8
class NakedSingleStrategy < Strategy
  def solve(board)
    # NakedSingle 一つのマスに配置できる数字が一つに限られる場合、そこに入る数字が確定する
    result = false
    cells = board.get_empty_cells
    cells.each do |cell|
      if cell.candidates.size == 1
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
