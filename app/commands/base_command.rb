class BaseCommand

  def self.execute(*args)
    new(*args).execute
  end

  def execute
    raise "Please implement execute method"
  end

end

