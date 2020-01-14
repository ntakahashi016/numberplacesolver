# coding: utf-8
class LastDigitStrategy < Strategy
  def solve(board)
    # LastDigit ある数字が8つ既に入っている場合、残りの一つが確定する
    result = false
    cells = board.get_cells.flatten
    num_count = {}
    cells.each do |cell|
      next if cell==nil
      unless num_count.member?(cell.n)
        num_count[cell.n] = 0
      end
      num_count[cell.n] += 1
    end
    num_count.each do |number,count|
      next unless count==(board.n_max-1)
      empty_cells = board.get_empty_cells
      empty_cells.each do |cell|
        next unless cell.candidates.include?(number)
        puts "#####{self.class.name}##{__method__}:#{cell.x.to_s},#{cell.y.to_s} => #{number.to_s}"
        board.set_number(cell.x, cell.y, number)
        board.update_candidates
        puts board.to_s
        result = true
      end
    end
    result
  end
end
