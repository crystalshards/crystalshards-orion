require "./has_version"
require "./git_ref"

class Manifest::Shard::Dependency::Gitlab
  include JSON::Serializable
  include YAML::Serializable
  include HasVersion
  include GitRef

  getter gitlab : String

  def provider
    "gitlab"
  end

  def uri
    gitlab
  end
end
