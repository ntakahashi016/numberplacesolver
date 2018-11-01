# coding: utf-8
class Cell

  def initialize(number=nil)
    @number = number
    @observers = []
  end

  def is_blank?()
    if @number.value == nil
      true
    end
    false
  end

  def add_observer(observer)
    unless observer.class == SolveUnit
      raise e
    end
    @observers.add(observer)
  end

  def del_observer(observer)
    if @observers.include?(observer)
      @observres.del(observer)
    else
      #エラー処理が必要か？
      raise e
    end
  end

  def notify_observer()
    @obsevers.each do |observer|
      observer.notify
    end
  end
end
