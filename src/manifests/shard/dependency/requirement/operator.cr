class Manifest::Shard::Dependency::Requirement::Operator
  MAPPING = {
    "="  => "EQ",   # Equal
    "<=" => "LTE",  # Less Than or Equal To
    ">=" => "GTE",  # Greater Than or Equal To
    ">"  => "GT",   # Greater Than
    "<"  => "LT",   # Less Than
    "~>" => "GTIR", # Greater Than in Range
  }

  getter operator : String
  getter id : String

  def self.to_column(id : String) : self
    new(id: id)
  end

  def self.to_column(id : Nil) : Nil
    nil
  end

  def self.to_column(id) : self
    raise "Unsupported type: #{id.class.name}"
  end

  def self.to_db(operator : self)
    operator.id
  end

  def self.to_db(operator : Nil)
    nil
  end

  def initialize(*, @id)
    @operator = MAPPING.invert[@id]
  end

  def initialize(*, @operator : String)
    @id = MAPPING[@operator]
  end

  def to_s
    operator
  end
end
