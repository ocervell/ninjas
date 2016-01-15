require_relative '../item'

class Heal < Item
  attr_reader :power
  def initialize
    @type = "heal"
    @cap = 5
    super
  end

  def use!(object, amount)
    #object can be anything: creature, weapon ...
    if object.method_defined?(:heal!)
      object.heal!(amount)
    end
  end

end