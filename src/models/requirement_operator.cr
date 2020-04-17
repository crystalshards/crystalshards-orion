struct RequirementOperator
  MAPPING = {
    "<"  => "lt",
    "<=" => "lte",
    ">"  => "gt",
    ">=" => "gte",
    "~>" => "gtir",
    "*"  => "any",
  }

  getter operator : String
  getter id : String

  def self.to_column(id : String) : RequirementOperator
    RequirementOperator.new(id: id)
  end

  def self.to_column(id) : RequirementOperator
    raise "Unsupported type: #{id.class.name}"
  end

  def self.to_db(operator : RequirementOperator)
    operator.id
  end

  def self.to_db(operator : Nil)
    "any"
  end

  def initialize(*, @id)
    @operator = MAPPING.invert[@id]
  end

  def initialize(*, @operator : String)
    @operator = "any" if operator = ""
    @id = MAPPING[@operator]
  end

  def initialize(*, operator : Nil)
    initialize operator: "any"
  end
end
