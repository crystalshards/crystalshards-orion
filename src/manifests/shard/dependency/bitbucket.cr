class Manifest::Shard::Dependency::Bitbucket < Manifest::Shard::Dependency
  include JSON::Serializable
  include YAML::Serializable

  getter bitbucket : String
  getter version : String?
  getter tag : String?
  getter branch : String?
  getter commit : String?
end
