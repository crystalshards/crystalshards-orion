class Manifest::Shard::Dependency::Path
  include JSON::Serializable
  include YAML::Serializable

  getter path : String
  getter version : String?
end
