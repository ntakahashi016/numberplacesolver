# coding: utf-8
class Number
  @@min_vlaue = 1
  @@max_value = 9
  attr_reader:value

  def initialize()
    @value = nil
  end

  def self.set_min_value(value)
    if value < @@max_value
      @@min_value = vslue
    else
      raise "Class:#{self.class.name} cannot set value lager than max_value to min_value"
    end
  end

  def self.set_max_value(valuea)
    if @@min_value < value
      @@max_value = value
    else
      raise "Class:#{self.class.name} cannot set value less than min_value to max_value"
    end
  end

  def value=(value)
    if (@@min_value <= value) and (value <= @@max_value)do
         @value = value
       end
    else
      raise "Class:#{self.class.name} RangeError"
    end
  end

  def value
    @vlue
  end

end
