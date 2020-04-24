class Manifest::Target
  include JSON::Serializable
  include YAML::Serializable

  getter main : String
end
