class Manifest::Shard::Dependency::Github
  include JSON::Serializable
  include YAML::Serializable

  getter github : String
  getter version : String?
  getter tag : String?
  getter branch : String?
  getter commit : String?
end
