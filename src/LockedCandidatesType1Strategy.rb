# coding: utf-8
class LockedCandidatesType1Strategy < Strategy
    def solve(board)
    # 同一領域(ボックス)内で直線状に並んだ候補があれば他の領域(ボックス)におけるその行または列から候補を排除できる
    result = false
    cells = board.get_empty_cells
    i = 0
    j = 0
    for i in 0...(cells.size-1) do
      same_row_candidates = [] # 同一行に属する候補
      same_cul_candidates = [] # 同一列に属する候補
      same_falling_diagonal_candidates = [] # 同一対角線に属する候補
      same_raising_diagonal_candidates = [] # 同一対角線に属する候補
      other_candidates    = [] # 直線上にない候補
      for j in 0...cells.size do
        # i==jのとき同一のCellをチェックすることになるため無視する
        next if i==j
        # jのループ内でcells[i]と同一ボックス内にある他のマスをチェックする
        # cells[i]と同一のボックスにcells[j]が属していない場合無視する
        next unless cells[i].box_constraints.any? { |c| c.include?(cells[j]) }
        if cells[i].row_constraints.any? { |c| c.include?(cells[j]) }
          # cells[i]と同じ行にcells[j]が属している場合の共通の候補を保存する
          same_row_candidates |= cells[i].candidates & cells[j].candidates
        elsif cells[i].cul_constraints.any? { |c| c.include?(cells[j]) }
          # cells[i]と同じ列にcells[j]が属している場合の共通の候補を保存する
          same_cul_candidates |= cells[i].candidates & cells[j].candidates
        elsif cells[i].falling_diagonal_constraints.any? { |c| c.include?(cells[j]) }
          # cells[i]と同じ対角線にcells[j]が属している場合の共通の候補を保存する
          same_falling_diagonal_candidates |= cells[i].candidates & cells[j].candidates
        elsif cells[i].raising_diagonal_constraints.any? { |c| c.include?(cells[j]) }
          # cells[i]と同じ対角線にcells[j]が属している場合の共通の候補を保存する
          same_raising_diagonal_candidates |= cells[i].candidates & cells[j].candidates
        else
          # cells[i]とcells[j]が同一の行または列に属さない場合の共通の候補を保存する
          other_candidates |= cells[j].candidates
        end
        # 演算用に一時保存する
        tmp_same_row_candidates = same_row_candidates
        tmp_same_cul_candidates = same_cul_candidates
        tmp_same_falling_diagonal_candidates = same_falling_diagonal_candidates
        tmp_same_raising_diagonal_candidates = same_raising_diagonal_candidates
        # 同一の行にある共通の候補だが、同一の行以外にも属しているものを排除する
        same_row_candidates   -= tmp_same_cul_candidates | tmp_same_falling_diagonal_candidates | tmp_same_raising_diagonal_candidates | other_candidates
        # 同一の列にある共通の候補だが、同一の列以外にも属しているものを排除する
        same_cul_candidates   -= tmp_same_row_candidates | tmp_same_falling_diagonal_candidates | tmp_same_raising_diagonal_candidates | other_candidates
        # 同一の対角線にある共通の候補だが、同一の対角線以外にも属しているものを排除する
        same_falling_diagonal_candidates -= tmp_same_cul_candidates | tmp_same_row_candidates | tmp_same_raising_diagonal_candidates | other_candidates
        # 同一の対角線にある共通の候補だが、同一の対角線以外にも属しているものを排除する
        same_raising_diagonal_candidates -= tmp_same_cul_candidates | tmp_same_row_candidates | tmp_same_falling_diagonal_candidates | other_candidates
        # 同一の行、同一の列双方に属する場合、直線状でない候補として保存する
        other_candidates |= (tmp_same_row_candidates & tmp_same_cul_candidates) |
                            (tmp_same_row_candidates & tmp_same_falling_diagonal_candidates) |
                            (tmp_same_cul_candidates & tmp_same_falling_diagonal_candidates) |
                            (tmp_same_row_candidates & tmp_same_raising_diagonal_candidates) |
                            (tmp_same_cul_candidates & tmp_same_raising_diagonal_candidates) |
                            (tmp_same_falling_diagonal_candidates & tmp_same_raising_diagonal_candidates)
      end
      row_constraints = cells[i].row_constraints
      cul_constraints = cells[i].cul_constraints
      box_constraints = cells[i].box_constraints
      falling_diagonal_constraints = cells[i].falling_diagonal_constraints
      raising_diagonal_constraints = cells[i].raising_diagonal_constraints
      unless same_row_candidates==[]
        # cells[i]と同一の行に共通の候補がある場合
        row_constraints.product(box_constraints).each do |constraints|
          # cells[i]と同一の行及びボックスのうち空のマスを対象とする
          target_cells = (constraints.first.cells - constraints.last.cells) & cells
          target_cells.each do |cell|
            # 対象のマスの候補から直線状に並んだ候補を削除する
            prev_candidates = cell.candidates
            after_candidates = cell.delete_candidates(same_row_candidates)
            result = true if prev_candidates!=after_candidates
          end
        end
      end
      unless same_cul_candidates==[]
        # cells[i]と同一の列に共通の候補がある場合
        cul_constraints.product(box_constraints).each do |constraints|
          # cells[i]と同一の列及びボックスのうち空のマスを対象とする
          target_cells = (constraints.first.cells - constraints.last.cells) & cells
          target_cells.each do |cell|
            # 対象のマスの候補から直線状に並んだ候補を削除する
            prev_candidates = cell.candidates
            after_candidates = cell.delete_candidates(same_cul_candidates)
            result = true if prev_candidates!=after_candidates
          end
        end
      end
      unless same_falling_diagonal_candidates==[]
        falling_diagonal_constraints.product(box_constraints).each do |constraints|
          target_cells = (constraints.first.cells - constraints.last.cells) & cells
          target_cells.each do |cell|
            prev_candidates = cell.candidates
            after_candidates = cell.delete_candidates(same_falling_diagonal_candidates)
            result = true if prev_candidates!=after_candidates
          end
        end
      end
      unless same_raising_diagonal_candidates==[]
        raising_diagonal_constraints.product(box_constraints).each do |constraints|
          target_cells = (constraints.first.cells - constraints.last.cells) & cells
          target_cells.each do |cell|
            prev_candidates = cell.candidates
            after_candidates = cell.delete_candidates(same_raising_diagonal_candidates)
            result = true if prev_candidates!=after_candidates
          end
        end
      end
    end
    # 候補の絞り込みに成功すればtrueを返す
    result
  end

end
