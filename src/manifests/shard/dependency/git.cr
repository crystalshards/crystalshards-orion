class Manifest::Shard::Dependency::Git < Manifest::Shard::Dependency
  include JSON::Serializable
  include YAML::Serializable

  getter git : String
  getter tag : String?
  getter branch : String?
  getter commit : String?
end
