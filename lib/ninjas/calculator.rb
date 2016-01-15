module Calculator
  $xp_base = 100
  $xp_base_kill = 100

  def self.xp_required(level)
    xp = $xp_base*level
  end

  def self.xp_gained(source_level, dest_level)
    #WILL DEPEND ON MANY MORE ARGUMENTS LATER
    delta = dest_level - source_level + 1
    xp = delta*$xp_base + $xp_base_kill
  end
end