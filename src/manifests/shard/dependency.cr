class Manifest::Shard::Dependency
  include JSON::Serializable
  include YAML::Serializable
end

require "./dependency/*"
