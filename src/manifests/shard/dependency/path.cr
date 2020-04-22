require "./requirement"

class Manifest::Shard::Dependency::Path
  include JSON::Serializable
  include YAML::Serializable
  include HasVersion

  getter path : String

  def provider
    "path"
  end

  def uri
    path
  end

  def ref_type
    nil
  end

  def ref_name
    nil
  end
end
