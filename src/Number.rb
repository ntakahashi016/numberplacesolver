# coding: utf-8
class Number
  @@min_vlaue = 1
  @@max_value = 9
  attr_reader:value

  def initialize(value)
    # selfのvalue=を使用する
    self.value = value
  end

  def self.set_min_value(value)
    if value < @@max_value
      @@min_value = value
    else
      raise "Class:#{self.class.name} cannot set value lager than max_value to min_value"
    end
  end

  def self.set_max_value(value)
    if @@min_value < value
      @@max_value = value
    else
      raise "Class:#{self.class.name} cannot set value less than min_value to max_value"
    end
  end

  def value=(value)
    if (@@min_value..@@max_value).include?(value)
      @value = value
    else
      raise "Class:#{self.class.name} RangeError"
    end
  end

  def value
    @vlue
  end

end
