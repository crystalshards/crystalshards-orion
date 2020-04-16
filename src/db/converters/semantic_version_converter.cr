module SemanticVersionConverter
  def self.to_column(version_string : String) : SemanticVersion
    SemanticVersion.parse(version_string)
  end

  def self.to_column(any) : Nil
    nil
  end

  def self.to_db(semantic_version : SemanticVersion?)
    semantic_version.to_s if (semantic_version)
  end
end
