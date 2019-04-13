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
        state = :naked_single
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
        state = changed ? :init : :narrow_down_by_linear_candidates
      when :narrow_down_by_linear_candidates
        # 直線状に並んだ候補を検出し、その行または列から候補を排除する
        changed = narrow_down_by_linear_candidates
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
    puts @board.to_s
    cells.each do |cell|
      # いずれかの領域で数字を確定できたらresultをtrueにする
      target_cells = cells & cell.row_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(cell,target_cells)

      target_cells = cells & cell.col_constraints.inject([]) { |a,c| a |= c.cells }
      result |= __fix_hidden_single(cell,target_cells)

      target_cells = cells & cell.box_constraints.inject([]) { |a,c| a |= c.cells }
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

  def narrow_down_by_linear_candidates
    # 同一領域(ボックス)内で直線状に並んだ候補があれば他の領域(ボックス)におけるその行または列から候補を排除できる
    result = false
    cells = @board.get_empty_cells
    i = 0
    j = 0
    for i in 0...(cells.size-1) do
      same_row_candidates   = [] # 同一行に属する候補
      same_col_candidates   = [] # 同一列に属する候補
      non_linear_candidates = [] # 直線上にない候補
      for j in 0...cells.size do
        # i==jのとき同一のCellをチェックすることになるため無視する
        next if i==j
        # jのループ内でcells[i]と同一ボックス内にある他のマスをチェックする
        # cells[i]と同一のボックスにcells[j]が属していない場合無視する
        next unless cells[i].box_constraints.any? { |c| c.include?(cells[j]) }
        if cells[i].row_constraints.any? { |c| c.include?(cells[j]) }
          # cells[i]と同じ行にcells[j]が属している場合の共通の候補を保存する
          same_row_candidates |= cells[i].candidates & cells[j].candidates
        elsif cells[i].col_constraints.any? { |c| c.include?(cells[j]) }
          # cells[i]と同じ列にcells[j]が属している場合の共通の候補を保存する
          same_col_candidates |= cells[i].candidates & cells[j].candidates
        else
          # cells[i]とcells[j]が同一の行または列に属さない場合の共通の候補を保存する
          non_linear_candidates |= cells[j].candidates
        end
        # 演算用に一時保存する
        tmp_same_row_candidates = same_row_candidates
        tmp_same_col_candidates = same_col_candidates
        # 同一の行にある共通の候補だが、同一の行以外にも属しているものを排除する
        same_row_candidates   -= tmp_same_col_candidates | non_linear_candidates
        # 同一の列にある共通の候補だが、同一の列以外にも属しているものを排除する
        same_col_candidates   -= tmp_same_row_candidates | non_linear_candidates
        # 同一の行、同一の列双方に属する場合、直線状でない候補として保存する
        non_linear_candidates |= tmp_same_row_candidates & tmp_same_col_candidates
      end
      row_constraints = cells[i].row_constraints
      col_constraints = cells[i].col_constraints
      box_constraints = cells[i].box_constraints
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
      unless same_col_candidates==[]
        # cells[i]と同一の列に共通の候補がある場合
        col_constraints.product(box_constraints).each do |constraints|
          # cells[i]と同一の列及びボックスのうち空のマスを対象とする
          target_cells = (constraints.first.cells - constraints.last.cells) & cells
          target_cells.each do |cell|
            # 対象のマスの候補から直線状に並んだ候補を削除する
            prev_candidates = cell.candidates
            after_candidates = cell.delete_candidates(same_col_candidates)
            result = true if prev_candidates!=after_candidates
          end
        end
      end
    end
    # 候補の絞り込みに成功すればtrueを返す
    result
  end

end
