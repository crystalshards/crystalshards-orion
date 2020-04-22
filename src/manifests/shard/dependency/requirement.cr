require "../../string_parser.cr"

class Manifest::Shard::Dependency::Requirement
  include StringParser

  getter operator : Operator?
  getter version : String?

  def initialize(requirement : String)
    requirement = requirement.strip
    operator = Operator::MAPPING.keys.find do |key|
      requirement.starts_with? key
    end
    @version = operator ? requirement.lchop(operator).strip : requirement
    @operator = operator ? Operator.new(operator: operator) : nil
  end

  def to_s
    [operator, version].compact.map(&.to_s).join(" ")
  end

  def to_yaml(builder)
    to_s.to_yaml(builder)
  end

  def to_json(builder)
    to_s.to_json(builder)
  end
end

require "./requirement/*"
