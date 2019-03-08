# coding: utf-8
class Cell

  def initialize(number=nil)
    # Number must has value
    # blank Cell has nil
    @number = number
    @observers = []
  end

  def is_blank?()
    if @number == nil
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
      @observres.delete(observer)
    else
      #エラー処理が必要か？
      raise e
    end
  end

  def notify_observers()
    @obsevers.each do |observer|
      observer.notify
    end
  end

  def number=(number)
    begin
      @number=number
      self.notify_observers
    rescue
    end
  end
end
