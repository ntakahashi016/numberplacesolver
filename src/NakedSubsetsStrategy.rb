# coding: utf-8
class NakedSubsetsStrategy < Strategy
  def initialize(n=2)
    @n = n
  end
  def solve(board)
    # Naked Subsets 同じ領域で2種類の数字が配置できるマスが同じ2マスに限られそのマスに他の数字が候補にない場合、その領域から2種類の数字の候補を削除できる
    # Locked Pair Naked Subsetsでかつ2つのマスが同じ行同じボックス、または同じ列同じボックスの場合両方の領域から候補を削除できる
    result = false
    constraints = board.get_unsolved_constraints
    constraints.each do |constraint|
      cells = constraint.get_empty_cells
      candidates = constraint.candidates
      cells_by_candidate = {} # 候補をキーとしその候補が入りうるマスの配列を値とするハッシュ
      candidates.each do |candidate|
        cells_by_candidate[candidate] = (cells.select{|cell| cell.candidates.include?(candidate) })
      end

      naked_subset = {}
      cells_by_candidate.keys.combination(@n).each do |candidates|
        cells_by_combination = []
        candidates.each do |candidate|
          cells_by_combination |= cells_by_candidate[candidate]
        end
        cells_naked_subset = cells_by_combination.select do |cell|
          cell.candidates - candidates == []
        end
        next unless cells_naked_subset.size == @n
        naked_subset[candidates] = cells_naked_subset
      end

      next if naked_subset == {}

      naked_subset.each_key do |candidates|
        candidates.each do |candidate|
          target_cells = cells_by_candidate[candidate] - naked_subset[candidates]
          target_cells.each do |cell|
            prev_candidates = cell.candidates
            target = candidates
            next if target == []
            after_candidates = cell.delete_candidates(target)
            puts "#####{self.class.name}##{__method__}(#{@n}):#{cell.x.to_s},#{cell.y.to_s} #{prev_candidates} => #{after_candidates}"
            result = true if prev_candidates != after_candidates
          end
        end
      end
    end
    result
  end
end
