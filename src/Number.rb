# coding: utf-8

# Number
# マス(Cellオブジェクト)に登録する数字
# 範囲外の数字は設定できない
class Number
  @@min_value = 1
  @@max_value = 9

  # 初期化
  # Numberオブジェクトに値を設定する
  # 範囲外の値を指定された場合例外が発生する
  def initialize(value)
    if (@@min_value..@@max_value).include?(value)
      @value = value
    else
      raise RangeError,"Class:#{self.class.name} 初期化に失敗しました。範囲内(#{@@min_value.to_s}..#{@@max_value.to_s})の値を指定してください。(値＝#{value.to_s})"
    end
  end

  # Number.set_min_value
  # Numberクラスで扱う数字の最小値を設定する
  # 最大値よりも大きい値を指定した場合例外が発生する
  def self.set_min_value(value)
    if value < @@max_value
      @@min_value = value
    else
      raise RangeError,"Class:#{self.class.name} 現在の最大値(#{@@max_value.to_s})以上の値は最小値として設定できません。(値＝#{value.to_s})"
    end
  end

  # Number.set_max_malue
  # Numberクラスで扱う数字の最大値を設定する
  # 最小値よりも小さい値を指定した場合例外が発生する
  def self.set_max_value(value)
    if @@min_value < value
      @@max_value = value
    else
      raise RangeError,"Class:#{self.class.name} 現在の最小値(#{@@min_value.to_s})以下の値は最大値として設定できません。(値＝#{value.to_s})"
    end
  end

  # Number.available_values
  # Numberクラスで設定可能な数字を配列で返す
  def self.available_values()
    (@@min_value..@@max_value).to_a
  end

  # to_i
  # 値を整数で返す
  def to_i
    @value
  end

end


# test
if $0 == __FILE__
  puts "#### Number.new ####"
  0.upto(10) do |i|
    result = ""
    begin
      result << "Number.new(#{i}) : "
      num = Number.new(i)
      result << "OK"
    rescue => e
      result << "NG" + " " + e.message
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
    rescue => e
      result << "NG" + " " + e.message
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
    rescue => e
      result << "NG" + " " + e.message
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
    rescue => e
      result << "NG" + " " + e.message
    ensure
      puts result
    end
  end
end
