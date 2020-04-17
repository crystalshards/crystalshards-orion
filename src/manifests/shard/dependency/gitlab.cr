class Manifest::Shard::Dependency::Gitlab
  include JSON::Serializable
  include YAML::Serializable

  getter gitlab : String
  getter version : String?
  getter tag : String?
  getter branch : String?
  getter commit : String?
end
