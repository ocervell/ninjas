require_relative '../monster'

class BigSpider < Monster
  def initialize
    @max_health = 2000
    super
  end
end