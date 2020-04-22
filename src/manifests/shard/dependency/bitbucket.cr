require "./has_version"
require "./git_ref"

class Manifest::Shard::Dependency::Bitbucket
  include JSON::Serializable
  include YAML::Serializable
  include HasVersion
  include GitRef

  getter bitbucket : String

  def provider
    "bitbucket"
  end

  def uri
    "https://bitbucket.org/#{bitbucket}"
  end
end
