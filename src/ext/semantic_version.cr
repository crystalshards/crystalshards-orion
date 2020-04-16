class SemanticVersion
  def matches?(requirement : String)
    Shards::Versions.matches?(to_s, requirement)
  end
end
