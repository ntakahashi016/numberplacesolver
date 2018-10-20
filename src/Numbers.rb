class Numbers

  def initialize()
    @numbers = Set.new
  end

  def add_number(number)
    @numbers.add(number)
  end

  def del_number(number)
    @numbers.del(number)
  end

  def [](index)
    @number[index]
  end

  def include?(number)
    @numbers.include?(number)
  end

  def is_blank?()
    if @numbers.size == 0
      true
    else
      false
    end
  end
end
