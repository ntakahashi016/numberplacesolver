# coding: utf-8
class SolveUnit

  def intialize(unfixed_numbers)
    @cells = []
    @unfixed_numbers = unfixed_numbers
  end

  # 参照しているCellに更新があったことの通知
  def notify()
    # すでにすべての数字が確定している場合無視する
    if !self.is_fixed?
      # s6tep 1 確定している数字を確認し@unfixed_numbersを更新する
      fixed_numbers = [] # 今回新たに確定した数字を記録しておく
      @cells.each do |cell|
        if !cell.is_blank?
          # 数字が確定しているCellのみ対象とする
          number = cell.number
          if @unfixed_numbers.include?(number)
            # 未確定だった数字が確定していた場合
            @unfixed_numbers.del_number(number)
            fixed_numbers.add(number)
          end
        end
      end
      # step 2 空白cellの候補から確定した数字を除外する
      if fixed_numbers != [] # 今回新たに確定した数字がなかったら無視する
        @cells.each do |cell|
          if cell.is_blank?
            # 数字が確定していないCellのみ対象とする
            fixed_numbers.each do |number|
              cell.del_candidate(number)
            end
          end
        end
      end
    end
  end

  def is_fixed?()
    @unfixed_numbers.is_blank?
  end

  def get_unfixed_numbers()
    @get_unfixed_numbers
  end

end
