class BaseCommand
  def self.execute(...)
    new(...).execute
  end

  def execute
    raise NotImplementedError, "Subclasses must implement #execute"
  end
end
