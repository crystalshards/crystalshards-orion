require "./has_version"
require "./git_ref"

class Manifest::Shard::Dependency::Github
  include JSON::Serializable
  include YAML::Serializable
  include HasVersion
  include GitRef

  getter github : String

  def provider
    "github"
  end

  def uri
    "https://github.com/#{github}"
  end
end
