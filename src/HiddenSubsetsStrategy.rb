# coding: utf-8
class HiddenSubsetsStrategy < Strategy
  def initialize(n)
    @n = n
  end
  def solve(board)
    # Hidden pair 同じ領域で2種類の数字が配置できるマスが同じ2マスに限られる場合、その領域から他の候補を排除する
    result = false
    constraints = board.get_unsolved_constraints
    constraints.select do |constraint|
      cells = constraint.get_empty_cells
      candidates = constraint.candidates
      cells_by_candidate = {} # 候補をキーとしその候補が入りうるマスの配列を値とするハッシュ
      candidates.each do |candidate|
        cells_by_candidate[candidate] = (cells.select{|cell| cell.candidates.include?(candidate) })
      end

      # ある候補のは入りうるマスの集合がもう一つの候補の入りうるマスの集合と包含関係にあるか調べる
      # A=BのときはAがBを包含するという関係のみを保存する
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

      hidden_subset = {}
      including_relation_hash.each do |a,bs|
        tmp_subset = cells_by_candidate[a]
        bs.each do |b|
          tmp_subset &= cells_by_candidate[a] - cells_by_candidate[b]
        end
        next if tmp_subset != []
        hidden_subset[a] = [] unless hidden_subset[a]
        hidden_subset[a] << a
        bs.each { |b| hidden_subset[a] << b }
      end

      exclusive = []
      hidden_subset.each_key do |a|
        exclusive << a if cells_by_candidate[a].size != @n || hidden_subset[a].size != @n
      end
      exclusive.each do |e|
        hidden_subset.delete(e)
      end

      hidden_subset.each_key do |a|
        cells_by_candidate[a].each do |cell|
          prev_candidates = cell.candidates
          target = cell.candidates - hidden_subset[a]
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
