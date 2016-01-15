require_relative '../creature'

class Player < Creature
  def initialize(name)
    @category = "Player"
    super(name)
  end

  public

  def about
    console.log "============ ABOUT ============"
    console.log "Name: #{@name}"
    console.log "Type: #{@type}"
    console.log "Level: #{@level}"
    console.log "Health: #{@health}"
    console.log "XP: #{@xp}/#{@xp_required}, Total XP: #{@xp_total}"
    console.log "Skills: #{@skills}"
    console.log "==============================="
  end
end