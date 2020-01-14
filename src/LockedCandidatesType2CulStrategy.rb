# coding: utf-8
class LockedCandidatesType2CulStrategy < Strategy
    def solve(board)
    # 同一領域(行または列)内である一つのボックスにのみある候補があれば同ボックス内の他のセルの候補を排除できる
    result = false
    cells = board.get_empty_cells
    i = 0
    j = 0
    for i in 0...(cells.size-1) do
      same_cul_candidates = [] # 同一列に属する候補
      other_cul_candidates = [] # 同一列に属するがボックスが異なる候補
      for j in 0...cells.size do
        # i==jのとき同一のCellをチェックすることになるため無視する
        next if i==j
        # jのループ内でcells[i]と同一ボックス内にある他のマスをチェックする
        # cells[i]と同一のボックスにcells[j]が属していない場合無視する
        next unless cells[i].box_constraints.any? { |c| c.include?(cells[j]) }
        if cells[i].cul_constraints.any? { |c| c.include?(cells[j]) }
          # cells[i]と同じ列にcells[j]が属している場合の共通の候補を保存する
          same_cul_candidates |= cells[i].candidates & cells[j].candidates
        else
          # cells[i]と同じボックスにcells[j]が属しているが、行列ともに異なる場合無視する
          next
        end
        # 同一の列に属する候補が存在する場合、同一の行で異なるボックスに属するマスに共通の候補がある場合除外するために保存する
        unless same_cul_candidates == []
          cells[i].cul_constraints.each do |c|
            c.cells.each do |cell|
              # 空のセルでなければ無視
              next unless cells.include?(cell)
              # 同一のボックスに含まれる場合は無視
              next unless cells[i].box_constraints.none? { |c| c.include?(cell) }
              other_cul_candidates |= cell.candidates
            end
          end
        end
        # 演算用に一時保存する
        tmp_same_cul_candidates = same_cul_candidates
        # 同一の列にある候補だが、異なるボックスにも存在する候補を排除する
        same_cul_candidates -= other_cul_candidates
      end
      cul_constraints = cells[i].cul_constraints
      box_constraints = cells[i].box_constraints
      unless same_cul_candidates==[]
        box_constraints.product(cul_constraints).each do |constraints|
          target_cells = (constraints.first.cells - constraints.last.cells) & cells
          target_cells.each do |cell|
            next if same_cul_candidates & cell.candidates == []
            prev_candidates = cell.candidates
            after_candidates = cell.delete_candidates(same_cul_candidates)
            puts "#####{self.class.name}##{__method__}:#{cell.x.to_s},#{cell.y.to_s} #{prev_candidates} => #{after_candidates}"
            result = true if prev_candidates != after_candidates
          end
        end
      end
    end
    # 候補の絞り込みに成功すればtrueを返す
    result
  end
end
