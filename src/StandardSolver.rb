# coding: utf-8

require './Solver'

class StandardSolver < Solver

  def initialize(board)
    super(board)
  end

  def solve()
    state = :init
    until @board.solved?
      case state
      when :init
        state = :last_digit
      when :last_digit
        # LastDigit ある数字が8つ既に入っている場合、残りの一つが確定する
        changed = fix_last_digit
        state = changed ? :init : :full_house
      when :full_house
        # FullHouse ある領域の8つのマスが既に埋まっている場合、残りの一つに入る数字が確定する
        changed = fix_full_house
        state = changed ? :init : :naked_single
      when :naked_single
        # NakedSingle 一つのマスに配置できる数字が一つに限られる場合、そこに入る数字が確定する
        changed = fix_naked_single
        state = changed ? :init : :hidden_single
      when :hidden_single
        # HiddenSingle ある数字が一つの領域で配置できるマスが一つに限られる場合、そこに入る数字が確定する
        changed = fix_hidden_single
        state = changed ? :init : :locked_candidates_type1
      when :locked_candidates_type1
        # LockedCandidates1 直線状に並んだ候補を検出し、その行または列から候補を排除する
        changed = remove_locked_candidates_type1
        state = changed ? :init : :locked_candidates_type2_row
      when :locked_candidates_type2_row
        # LockedCandiddates2 ある数字が一つの行で配置可能なマスが1つのボックスに限られる場合、そのボックスの他の行から候補を排除する
        changed = remove_locked_candidates_type2_row
        state = changed ? :init : :locked_candidates_type2_cul
      when :locked_candidates_type2_cul
        # LockedCandiddates2 ある数字が一つの列で配置可能なマスが1つのボックスに限られる場合、そのボックスの他の列から候補を排除する
        changed = remove_locked_candidates_type2_cul
        state = changed ? :init : :hidden_pair
      when :hidden_pair
        # Hidden pair 同じ領域で2種類の数字が配置できるマスが同じ2マスに限られる場合、その領域から他の候補を排除する
        changed = remove_hidden_subsets(2)
        state = changed ? :init : :hidden_triple
      when :hidden_triple
        # Hidden triple 同じ領域で3種類の数字が配置できるマスが同じ3マスに限られる場合、その領域から他の候補を排除する
        changed = remove_hidden_subsets(3)
        state = changed ? :init : :hidden_quadruple
      when :hidden_quadruple
        # Hidden triple 同じ領域で3種類の数字が配置できるマスが同じ3マスに限られる場合、その領域から他の候補を排除する
        changed = remove_hidden_subsets(4)
        state = changed ? :init : :fail
      when :fail
        raise "問題を解けませんでした"
      else
        raise "不明なStateです(#{state.to_s})"
      end
    end
  end

  private

  def fix_last_digit
    # LastDigit ある数字が8つ既に入っている場合、残りの一つが確定する
    result = false
    cells = @board.get_cells.flatten
    num_count = {}
    cells.each do |cell|
      next if cell==nil
      unless num_count.member?(cell.n)
        num_count[cell.n] = 0
      end
      num_count[cell.n] += 1
    end
    num_count.each do |number,count|
      next unless count==(@board.n_max-1)
      empty_cells = @board.get_empty_cells
      empty_cells.each do |cell|
        next unless cell.candidates.include?(number)
        puts "#####{__method__}:#{cell.x.to_s},#{cell.y.to_s} => #{number.to_s}"
        @board.set_number(cell.x, cell.y, number)
        @board.update_candidates
        puts @board.to_s
        result = true
      end
    end
    result
  end

  def fix_full_house
    # FullHouse ある領域の8つのマスが既に埋まっている場合、残りの一つに入る数字が確定する
    # NakedSingleの特殊パターンでもあるため、使用しなくてもfix_naked_singleで確定できる
    result = false
    cells = @board.get_empty_cells
    cells.each do |cell|
      if cell.row_constraints.any? { |c| c.cells.one? { |cell| cell.n == nil } }
        # (空の)cellの属する領域で空のマスが一つの場合、そのマスの候補(一つしか無いはず)が確定する
        puts "#####{__method__}:#{cell.x.to_s},#{cell.y.to_s} => #{cell.candidates.first.to_s}"
        @board.set_number(cell.x, cell.y, cell.candidates.first)
        @board.update_candidates
        puts @board.to_s
        result = true
      end
    end
    result
  end

  def fix_naked_single
    # NakedSingle 一つのマスに配置できる数字が一つに限られる場合、そこに入る数字が確定する
    result = false
    cells = @board.get_empty_cells
    cells.each do |cell|
      if cell.candidates.size == 1
        puts "#####{__method__}:#{cell.x.to_s},#{cell.y.to_s} => #{cell.candidates.first.to_s}"
        @board.set_number(cell.x, cell.y, cell.candidates.first)
        @board.update_candidates
        puts @board.to_s
        result = true
      end
    end
    result
  end

  def fix_hidden_single
    # HiddenSingle ある数字が一つの領域で配置できるマスが一つに限られる場合、そこに入る数字が確定する
    result = false
    cells = @board.get_empty_cells
    cells.each do |cell|
      # いずれかの領域で数字を確定できたらresultをtrueにする
      target_cells = cells & cell.row_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(cell,target_cells)

      target_cells = cells & cell.cul_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(cell,target_cells)

      target_cells = cells & cell.box_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(cell,target_cells)

      target_cells = cells & cell.falling_diagonal_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(cell,target_cells)

      target_cells = cells & cell.raising_diagonal_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(cell,target_cells)
    end
    result
  end

  def __fix_hidden_single(cell,target_cells)
    # fix_hidden_singleにおける共通処理
    # cellの各候補において同一領域(target_cells)内に配置できるマスがcellに限られるものがあるか調べる
    result = false
    cell.candidates.each do |candidate|
      same_candidate_cells = target_cells.map { |c| c if c.candidates.include?(candidate) }
      same_candidate_cells.compact!
      if same_candidate_cells==[cell]
        puts "#####{__method__}:#{cell.x.to_s},#{cell.y.to_s} => #{candidate.to_s}"
        @board.set_number(cell.x, cell.y, candidate)
        @board.update_candidates
        puts @board.to_s
        result = true
      end
    end
    result
  end

  def remove_locked_candidates_type1
    # 同一領域(ボックス)内で直線状に並んだ候補があれば他の領域(ボックス)におけるその行または列から候補を排除できる
    result = false
    cells = @board.get_empty_cells
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

  def remove_locked_candidates_type2_row
    # 同一領域(行または列)内である一つのボックスにのみある候補があれば同ボックス内の他のセルの候補を排除できる
    result = false
    cells = @board.get_empty_cells
    i = 0
    j = 0
    for i in 0...(cells.size-1) do
      same_row_candidates = [] # 同一行に属する候補
      other_row_candidates = [] # 同一行に属するがボックスが異なる候補
      for j in 0...cells.size do
        # i==jのとき同一のCellをチェックすることになるため無視する
        next if i==j
        # jのループ内でcells[i]と同一ボックス内にある他のマスをチェックする
        # cells[i]と同一のボックスにcells[j]が属していない場合無視する
        next unless cells[i].box_constraints.any? { |c| c.include?(cells[j]) }
        if cells[i].row_constraints.any? { |c| c.include?(cells[j]) }
          # cells[i]と同じ行にcells[j]が属している場合の共通の候補を保存する
          same_row_candidates |= cells[i].candidates & cells[j].candidates
        else
          # cells[i]と同じボックスにcells[j]が属しているが、行列ともに異なる場合無視する
          next
        end
        # 同一の行に属する候補が存在する場合、同一の行で異なるボックスに属するマスに共通の候補がある場合除外するために保存する
        unless same_row_candidates == []
          cells[i].row_constraints.each do |c|
            c.cells.each do |cell|
              # 空のセルでなければ無視
              next unless cells.include?(cell)
              # 同一のボックスに含まれる場合は無視
              next unless cells[i].box_constraints.none? { |c| c.include?(cell) }
              other_row_candidates |= cell.candidates
            end
          end
        end
        # 演算用に一時保存する
        tmp_same_row_candidates = same_row_candidates
        # 同一の行にある候補だが、異なるボックスにも存在する候補を排除する
        same_row_candidates -= other_row_candidates
      end
      row_constraints = cells[i].row_constraints
      box_constraints = cells[i].box_constraints
      unless same_row_candidates==[]
        # cells[i]と同一の行に共通の候補がある場合
        box_constraints.product(row_constraints).each do |constraints|
          # cells[i]と同一の行及び
          target_cells = (constraints.first.cells - constraints.last.cells) & cells
          target_cells.each do |cell|
            prev_candidates = cell.candidates
            after_candidates = cell.delete_candidates(same_row_candidates)
            puts "#####{__method__}:#{cell.x.to_s},#{cell.y.to_s} #{prev_candidates} => #{after_candidates}"
            result = true if prev_candidates != after_candidates
          end
        end
      end
    end
    # 候補の絞り込みに成功すればtrueを返す
    result
  end

  def remove_locked_candidates_type2_cul
    # 同一領域(行または列)内である一つのボックスにのみある候補があれば同ボックス内の他のセルの候補を排除できる
    result = false
    cells = @board.get_empty_cells
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
            prev_candidates = cell.candidates
            after_candidates = cell.delete_candidates(same_cul_candidates)
            puts "#####{__method__}:#{cell.x.to_s},#{cell.y.to_s} #{prev_candidates} => #{after_candidates}"
            result = true if prev_candidates != after_candidates
          end
        end
      end
    end
    # 候補の絞り込みに成功すればtrueを返す
    result
  end

  def remove_hidden_subsets(n=2)
    # Hidden pair 同じ領域で2種類の数字が配置できるマスが同じ2マスに限られる場合、その領域から他の候補を排除する
    result = false
    constraints = @board.get_unsolved_constraints
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
        exclusive << a if cells_by_candidate[a].size != n || hidden_subset[a].size != n
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
          puts "#####{__method__}(#{n}):#{cell.x.to_s},#{cell.y.to_s} #{prev_candidates} => #{after_candidates}"
          result = true if prev_candidates != after_candidates
        end
      end
    end
    result
  end
end
