class Manifest::Shard
  include JSON::Serializable
  include YAML::Serializable

  # Official Spec
  getter name : String
  getter version : String
  getter authors : Array(Shard::Author)?
  getter description : String?
  getter license : String?
  getter crystal : String?
  getter repository : String?
  getter homepage : String?
  getter documentation : String?
  getter dependencies : Hash(String, Dependency::Provider)?
  getter development_dependencies : Hash(String, Dependency::Provider)?
  getter executables : Array(String)?
  getter libraries : Hash(String, String)?
  getter scripts : Scripts?
  getter targets : Hash(String, Target)?

  # Unofficial
  getter tags : Array(String)?

  def self.to_column(value : JSON::Any) : Manifest::Shard?
    from_json value.to_json
  end

  def self.to_column(value : Manifest::Shard) : Manifest::Shard?
    value
  end

  def self.to_column(value : Nil) : Manifest::Shard?
    nil
  end

  def self.to_column(value) : Manifest::Shard?
    from_json value.to_s
  end

  def self.to_db(manifest : Manifest::Shard?)
    manifest.to_json
  end
end

require "./shard/*"
