class Manifest::Scripts
  include JSON::Serializable
  include YAML::Serializable

  getter postinstall : String
end
