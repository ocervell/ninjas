class Inventory
  @@max_items = 5
  attr_reader :items, :max_items
  attr_reader :owner

  def initialize(player)
    @max_items = @@max_items
    @items = []
    @nb_items = 0
    @owner = player
  end

  def status
    @owner.console.log("============ INVENTORY ============")
    return if @nb_items == 0
    weapons = filter_items_by_type('weapon')
    heals = filter_items_by_type('heal')
    tools = filter_items_by_type('tool')
    @owner.console.log("Weapons: ")
    weapons.each do |w|
      @owner.console.log("\t#{w.name} - Power: #{w.power}")
    end
    @owner.console.log("Heals: ")
    heals.each do |h|
      @owner.console.log("\t#{h.name} - Heal: #{h.power}")
    end
    @owner.console.log("Tools: ")
    tools.each do |t|
      @owner.console.log("\t#{t.name}")
    end
    @owner.console.log("===================================")
  end

  def add_items(items)
    return if items == []
    items.each do |item|
      add_item(item)
    end
  end

  def add_item(item)
    return if @nb_items == @capacity
    if filter_items_by_name(item.name).length >= item.cap
      @owner.console.log("You can't add #{item.name} because you reached the maximum capacity (#{item.cap}) for this item.")
      return
    end
    @items.push(item)
    @owner.console.log("Added #{item.name} (#{item.type}) to your inventory.")
    @nb_items += 1
  end

  def remove_item(item)
    return if @nb_items == 0
    @items.delete(item)
    @nb_items -= 1
  end

  def filter_items_by_type(type)
    return @items.select {|item| item.type == type}
  end

  def filter_items_by_name(name)
    return @items.select {|item| item.name == name}
  end

end
