class Manifest::Shard::Author
  property name : String
  property email : String?

  def self.new(pull : JSON::PullParser)
    new(pull.read_string)
  end

  def self.new(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
    ctx.read_alias(node, String) do |obj|
      return new obj
    end

    if node.is_a?(YAML::Nodes::Scalar)
      value = node.value
      ctx.record_anchor(node, value)
      new value
    else
      node.raise "Expected String, not #{node.class.name}"
    end
  end

  def initialize(name)
    if name =~ /\A\s*(.+?)\s*<(\s*.+?\s*)>/
      @name, @email = $1, $2
    else
      @name = name
    end
  end

  def to_yaml(builder)
    (email ? "#{name} <#{email}>" : name).to_yaml(builder)
  end

  def to_json(builder)
    (email ? "#{name} <#{email}>" : name).to_json(builder)
  end
end
