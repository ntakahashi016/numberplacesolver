# coding: utf-8

require './Block'
require './Number'

class Cell

  def initialize(x,y)
    @x = x          # X座標
    @y = y          # Y座標
    @number = nil   # 数字
    @observers = [] # 変更通知対象
  end

  # add_observer
  # observer(Blockオブジェクト)を追加する
  def add_observer(observer)
    unless observer.class == Block
      raise
    end
    @observers.push(observer)
  end

  # notify_observers
  # observerに変更があったことを通知する
  def notify_observers()
    @observers.each do |observer|
      begin
        observer.notify
      rescue => e
        raise e
      end
    end
  end

  # number=
  # 数字を設定する
  def number=(n)
    begin
      if n == nil
        @number = nil
      else
        @number = Number.new(n)
      end
      self.notify_observers
    rescue RangeError => e
      raise e
    rescue => e
      raise e
    end
  end

  # number
  # 数字を取得する
  def number()
    unless @number == nil
      @number.to_i
    else
      nil
    end
  end
end


# test
