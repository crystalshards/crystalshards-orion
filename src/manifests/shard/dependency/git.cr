require "./has_version"
require "./git_ref"

class Manifest::Shard::Dependency::Git
  include JSON::Serializable
  include YAML::Serializable
  include HasVersion
  include GitRef

  getter git : String

  def provider
    "git"
  end

  def uri
    git
  end
end
