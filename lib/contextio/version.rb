class ContextIO
  # contextio version
  VERSION = "0.5.0"

  def self.version
    VERSION
  end

  def version
    self.class.version
  end
end
