module Manifest::StringParser
  macro included
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
  end
end
