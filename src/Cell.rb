class Cell

  def initialize(number)
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
    @observers.add(observer)
  end

  def del_observer(observer)
    @observres.del(observer)
  end

  def notify_observer()
    @obsevers.each do |observer|
      observer.notify
    end
  end
end
