
class Strategy
  def solve
    raise "Override this method #{self.class}##{__method__}"
  end
end
