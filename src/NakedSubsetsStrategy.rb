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

      including_relation = cells_by_candidate.keys.combination(2).collect do |a,b|
        if (cells_by_candidate[a] | cells_by_candidate[b]) - cells_by_candidate[a] == []
          [a,b]
        elsif (cells_by_candidate[b] | cells_by_candidate[a]) - cells_by_candidate[b] == []
          [b,a]
        else
          nil
        end
      end

      including_relation.compact!

      including_relation_hash = {}
      including_relation.each do |a,b|
        including_relation_hash[a] = [] unless including_relation_hash[a]
        including_relation_hash[a] << b
      end

      naked_subset = {}
      including_relation_hash.each do |a,bs|
        tmp_subset = cells_by_candidate[a]
        bs.each do |b|
          tmp_subset &= cells_by_candidate[a] - cells_by_candidate[b]
        end
        next unless tmp_subset == []
        naked_subset[a] = [] unless naked_subset[a]
        naked_subset[a] << a
        bs.each { |b| naked_subset[a] << b }
      end
      puts naked_subset.to_s
      exclusive = []
      naked_subset.each_key do |a|
        if cells_by_candidate[a].size != @n || naked_subset[a].size != @n
          exclusive << a
        elsif cells_by_candidate[a].any? { |cell| cell.candidates - naked_subset[a] != [] }
          exclusive << a
        end
      end
      exclusive.each do |e|
        naked_subset.delete(e)
      end
      # puts naked_subset.to_s
      naked_subset.each_key do |a|
        cells_by_candidate[a].each do |cell|
          prev_candidates = cell.candidates
          target = cell.candidates - naked_subset[a]
          tmp = cell.candidates
          next if target == []
          after_candidates = cell.delete_candidates(target)
          puts "#####{self.class.name}##{__method__}(#{@n}):#{cell.x.to_s},#{cell.y.to_s} #{prev_candidates} => #{after_candidates}"
          result = true if prev_candidates != after_candidates
        end
      end
    end
    result
  end
end
