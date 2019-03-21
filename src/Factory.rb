# coding: utf-8

class Factory
  def generate
    raise "Class:#{self.class.name}##{__method__} abstract method called."
  end
end
