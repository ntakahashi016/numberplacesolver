# coding: utf-8

require './Number'

class AreadyExistsNumberError < StandardError; end

class Numbers

  def initialize()
    numbers = Number.available_values
    @numbers = numbers.zip(Array.new(numbers.length){false}).to_h
  end

  def set(n)
    if @numbers[n] == false
      @numbers[n] = true
    else
      raise "#{self.class.name} # #{n} is aready exists."
    end
  end

end
