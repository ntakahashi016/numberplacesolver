# coding: utf-8

class Number
  @@min_value = 1
  @@max_value = 9
  attr_reader:value

  def initialize(value)
    if (@@min_value..@@max_value).include?(value)
      @value = value
    else
      raise "Class:#{self.class.name} RangeError"
    end
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

  def self.available_values()
    (@@min_value..@@max_value).to_a
  end

  def to_i
    @value
  end

end


# test
__END__
puts "#### Number.new ####"
0.upto(10) do |i|
  result = ""
  begin
    result << "Number.new(#{i}) : "
    num = Number.new(i)
    result << "OK"
  rescue
    result << "NG"
  ensure
    puts result
  end
end
puts "#### Number.set_min_value ####"
Number.set_max_value(9)
puts "# current max_value is 9"
0.upto(10) do |i|
  result = ""
  begin
    result << "Number.set_min_value(#{i}) : "
    Number.set_min_value(i)
    result << "OK"
  rescue
    result << "NG"
  ensure
    puts result
  end
end
puts "#### Number.set_max_value ####"
Number.set_min_value(1)
puts "# current_min_value is 1"
10.downto(0) do |i|
  result = ""
  begin
    result << "Number.set_max_value(#{i}) : "
    Number.set_max_value(i)
    result << "OK"
  rescue
    result << "NG"
  ensure
    puts result
  end
end
puts "#### Number#available_values ####"
min = 1
max = 9
while min < max do
  result = ""
  Number.set_min_value(min)
  Number.set_max_value(max)
  result << "min=#{min},max=#{max} => "
  numbers = Number.available_values
  result << numbers.to_s
  puts result
  min += 1
  max -= 1
end
puts "#### Number#to_i ####"
Number.set_min_value(1)
Number.set_max_value(9)
0.upto(10) do |i|
  result = ""
  begin
    result << "Number.new(#{i}) : "
    num = Number.new(i)
    result << "to_i => #{num.to_i}"
  rescue
    result << "NG"
  ensure
    puts result
  end
end
