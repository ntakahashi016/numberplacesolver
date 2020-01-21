# coding: utf-8

require './Strategy'

class TemplateStrategy < Strategy

  def solve(board)
    until board.solved?
      prev = board.get_numbers
      base = generate_base(board)
      template = generate_template(board,base)
      template = fix_overlapped_same_numbers(board,template)
      template = delete_overlapped_differnt_numbers(board,template)
      numbers = generate_numbers(board,template)
      board.set_numbers(numbers)
      after = board.get_numbers
      break if prev == after
    end
  end

  private

  def generate_base(board)
    base = Hash.new
    for i in board.n_min..board.n_max do
      base[i] = Array.new
    end
    cells = board.get_cells - board.get_empty_cells
    cells.each do |cell|
      base[cell.n].push({x: cell.x, y: cell.y})
    end
    base
  end

  def generate_template(board,base)
    template = Hash.new
    for i in board.n_min..board.n_max do
      template[i] = Array.new
      possible    = Array.new
      for x in 0...board.x_size do
        for y in 0...board.x_size do
          # すでに何らかの数字が配置されているマスは無視する
          next if base.any? { |k,v| v.any? { |xy| xy[:x] == x && xy[:y] == y } }
          # 現在の数字が配置されているマスと同じ行は無視する
          next if base[i].any? { |xy| xy[:x] == x }
          # 現在の数字が配置されているマスと同じ列は無視する
          next if base[i].any? { |xy| xy[:y] == y }
          # 現在の数字が配置されているマスと同じブロックは無視する
          next if base[i].any? { |xy| (xy[:x]/Math.sqrt(board.x_size)).floor == (x/Math.sqrt(board.x_size)).floor &&
                                 (xy[:y]/Math.sqrt(board.x_size)).floor == (y/Math.sqrt(board.x_size)).floor }
          # 現在の数字を配置可能なマスをテンプレートに登録する
          possible.push({x: x, y: y})
        end
      end

      # 現在の数字を配置可能なマスが存在しない＝数字がそろっているため、baseをそのままテンプレートとして登録する
      if possible.size == 0
        template[i] = [base[i]]
        # テンプレート完成のため次へ
        next
      end

      idx = 0
      temp = Array.new
      base[i].each do |xy|
        temp.push(xy)
      end

      flag = false
      until flag
        # 可能性のあるマスに配置可能か判定する
        puttable = true
        puttable &= temp.none? { |xy| xy[:x] == possible[idx][:x] }
        puttable &= temp.none? { |xy| xy[:y] == possible[idx][:y] }
        puttable &= temp.none? { |xy| (xy[:x]/Math.sqrt(board.x_size)).floor == (possible[idx][:x]/Math.sqrt(board.x_size)).floor &&
                                 (xy[:y]/Math.sqrt(board.x_size)).floor == (possible[idx][:y]/Math.sqrt(board.x_size)).floor }
        # 配置可能ならテンプレートに登録する
        temp.push(possible[idx]) if puttable
        # 配置可能の如何に関わらず処理をしたらidxを進める
        idx += 1
        # temp.sizeがboard.x_size以上の場合、tempをtemplateに追加し、探索を継続
        template[i].push(temp.clone) if temp.size >= board.x_size && puttable
        while idx>=possible.size do
          # 最後に配置していたマスがpossibleに含まれない=すべての組をチェックし終えた
          unless possible.include?(temp.last)
            flag = true
            break
          end
          # 最後に配置していたマスを取り除く
          last = temp.pop
          # 最後に配置していたマスのpossible上での位置にidxを復帰させる
          idx = possible.index(last)
          # idxを進め、配置しなかったことにして次へ進める
          idx += 1
        end
      end
    end
    template
  end

  def fix_overlapped_same_numbers(board,template)
    t = Hash.new
    for i in board.n_min..board.n_max do
      t[i] = template[i].inject { |result,t| result &= t }
    end
    t
  end

  def delete_overlapped_differnt_numbers(board,template)
    delete_target = Array.new
    for i in board.n_min..board.n_max do
      delete_target[i] = Array.new
      used_xy = Array.new
      for j in board.n_min..board.n_max do
        next if i==j
        used_xy |= template[j]
      end
      template[i].each do |xy|
        delete_target[i].push(xy) if used_xy.include?(xy)
      end
    end
    for i in board.n_min..board.n_max do
      template[i] -= delete_target[i]
    end
    template
  end

  def generate_numbers(board,template)
    numbers = Array.new
    for i in 0..board.x_size do
      numbers[i] = Array.new
    end
    for i in board.n_min..board.n_max do
      next unless template[i]
      template[i].each do |xy|
        numbers[xy[:y]][xy[:x]] = i
      end
    end
    numbers
  end

end
