module SemanticVersionConverter
  def self.to_column(version_string : String) : SemanticVersion
    SemanticVersion.parse(version_string)
  end

  def self.to_db(semantic_version : SemanticVersion)
    semantic_version.to_s
  end
end
