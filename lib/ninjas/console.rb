class Console
  @@color_supported = false
  attr_accessor :show, :record

  def initialize(name='main')
    @name = name
    @show = true
    @record = true
    @logs = []
  end

  def to_s
    ret = ''
    @logs.each do |line|
      ret << "\n" + line
    end
    return ret
  end

  def log(entry)
    if @record == false
      @show = false
      return
    end

    # Put console name before message
    if @name == ''
      return
    elsif @name == 'main'
      pre = "  > "
    elsif @name == 'sim'
      if @@color_supported
        pre = @name.yellow + " $ ".yellow
      else
        pre = @name + " $ "
      end
    else
      pre = "  " + @name + " $ "
    end

    # Record msg in logs
    @logs << pre + entry

    # Display message if option enabled
    if @show == true
      puts pre + entry
    end
  end

  def log_error(entry)
    if @@color_supported
      log("[ERROR] ".red + entry.red) #ADD .RED
    else
      log("[ERROR] " + entry)
    end
  end

  def log_sim(entry)
    if @@color_supported
      log(entry.yellow)
    else
      log(entry)
    end
  end

  def self.colorize
    @@color_supported = true
  end

end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end