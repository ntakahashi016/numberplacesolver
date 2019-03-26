# coding: utf-8

require './Block'
require './Number'

class Cell

  attr_reader :x,:y,:candidates
  def initialize(x,y,n)
    @x = x          # X座標
    @y = y          # Y座標
    @n = n          # 数字の種類の数
    @number = nil   # 数字
    @observers = [] # 変更通知対象
    @candidates = (1..@n).to_a
  end

  # add_observer
  # observer(Blockオブジェクト)を追加する
  def add_observer(observer)
    unless observer.class == Block
      raise TypeError,"Class:#{self.class.name} ObserverにはBlockオブジェクトしか登録できません。(#{observer.class.name})"
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
        @caindidates = []
      end
      self.notify_observers
      self.refresh_candidates
    rescue RangeError => e
      raise e
    rescue TypeError => e
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

  def refresh_candidates
    if @number == nil
      @candidates = (1..@n).to_a
      @observers.each do |observer|
        @candidates &= observer.get_candidates
      end
      @candidates
    end
  end
end


# test
